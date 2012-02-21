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
  attr_accessor :name, :type, :title, :email, :phones, :fax, :toll_free
end

class Program
  attr_accessor :external_id, :category, :type, :products, :trademarks, :notes, :contacts
end

def getAttribute attribute, t
  t.match(Regexp.new("#{attribute}\n(?<#{attribute.downcase}>.*$)")) do |m|
    m[attribute.downcase.to_sym].split(";").collect { |p| p.strip }.join ", "
  end
end

def parseContacts text_data
  # "program contact" signals beginning of contacts
  # each contact is separated by an empty line
  contacts = []
  text_data.split(/\n /).each do |l|
    l.split("\n\n").each do |contact|
      unmatched = []
      c = Contact.new
      c.phones = []

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
          c.phones.push f.last.strip
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

        unmatched = unmatched.delete(-1) if unmatched.last.include? "All"
      end

      contacts.push c
    end
  end

  contacts
end

def parseProgram row
  p = Program.new
  p.external_id = row[9].split("-").first
  p.category = row[2]

  # parse details
  p.type = getAttribute "Type", row[4]
  p.products = getAttribute "Products", row[4]
  p.trademarks = getAttribute "Trademarks", row[4]
  p.notes = row[4]

  # parse contacts
  p.contacts = parseContacts p.notes.split("Personnel").last if p.notes.include? "Personnel"

  p
end

def readFile
  programs = []

  CSV.foreach("salesverge_programs.csv") do |row|
    next if row.last.eql? "updated_at"
    programs.push parseProgram row
  end
end

readFile
