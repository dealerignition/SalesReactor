#!/usr/bin/ruby
require "csv"

class String
  def isAttribute? a
    r = Regexp.new(a + ":" + "(?<" + a.to_sym.to_s + ">.*)")
    m = match(r)
    return [true, m[a.to_sym]] unless m.nil?

    [false]
  end
end

class Contact
  attr_accessor :name, :type, :title, :email, :phone, :fax, :toll_free
end

class Phone
  attr_accessor :type, :number
end

class Company
  attr_accessor :name, :city, :zipcode, :website, :address1, :address2, :state, :email, :website,
    :phones, :country, :contacts

  def parseAddress text
    @country = (text.include? "Canada") ? "Canada" : "USA"
    lines = text.partition("Personnel\n||").first.split("\n").delete_if do |l|
      l.eql? "||" or l.include? "Canada"
    end

    case lines.length
    when 0
      @address1 = nil
      @address2 = nil
    when 1..2
      @address1 = lines.first
      @address2 = lines.last unless lines.last.eql? lines.first
    else
      mid = lines.length / 2
      @address1 = lines[0..mid]
      @address2 = lines[mid+1..lines.length-1]
    end
  end
end

def parseContacts text_data
  # "program contact" signals beginning of contacts
  # each contact is separated by an empty line
  contacts = []
  text_data.split(/\n /).each do |l|
    l.split("\n\n").each do |contact|
      unmatched = []
      c = Contact.new()

      contact.split("\n").each do |row|
        # Skip empty lines
        next if row.strip.empty?

        # Try to match for specific type
       
        f = row.isAttribute? "Fax"
        if f.first
          c.fax = f.last.strip
          next
        end
        f = row.isAttribute? "Email"
        if f.first
          c.email = f.last.strip
          next
        end
        f = row.isAttribute? "Phone"
        if f.first
          c.phone = f.last.strip
          next
        end
        f = row.isAttribute? "Toll Free"
        if f.first
          c.toll_free = f.last.strip
          next
        end

        f = row.isAttribute? "Region"
        if f.first
          c.title = f.last.strip
          next
        end

        # Couldn't find specific type of information; put off parsing.
        unmatched = unmatched.push(row)
      end

      # Parse rows we put off.
      while not (unmatched.nil? or unmatched.empty?)
        # Contact Name
        # If the length is one, assume it's a name.
        if unmatched.count.eql? 1
          m = unmatched.first.match(/(?<name>[^\(\n]*)(?:\((?<title>.*?)\))?/)
          unless m.nil?
            unmatched = unmatched.delete(0)
            c.name = m[:name].strip
            c.title = m[:title].strip unless m[:title].nil?
          end
          next
        end

        # Contact Title (Or region)
        if unmatched.last.match /(east|west|south|north)/i
          c.title = unmatched.last
          unmatched = unmatched.delete(-1)
          next
        end

        # Contact Type
        if unmatched.first.include? "Contact"
          c.type = unmatched.first
          unmatched = unmatched.delete(0)
          next
        end
      end

      contacts.push c
    end
  end
end

def parseCompany row
  c = Company.new
  c.name = row[27].strip
  c.parseAddress row[6]
  c.city = row[3].strip
  c.zipcode = row[4].strip
  c.state = row[7].strip
  c.email = row[8].strip
  c.website = row[5].strip

  c.phones = []
  (11..26).reject { |i| i % 2 == 0 }.each do |i|
    unless row[i].eql? "NULL"
      p = Phone.new
      p.number = row[i]
      p.type = row[i+1]
      c.phones.push p
    end
  end

  c.contacts = parseContacts row[2].partition(/Personnel\nprogram contact/i).last

end

def readFile
  companies = []
  CSV.foreach(File.join"salesverge_companies.csv") do |row|
    next if row.last.eql? "company_name" #skip header row
    companies.push parseCompany row
  end
end

readFile
