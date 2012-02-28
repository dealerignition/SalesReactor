desc "Import the data from SalesVerge data sheets."


namespace :salesvergedata do
  task :import, [:args] => :environment do
    require "csv"

    class String
      def isAttribute? a
        r = Regexp.new(a + ":" + "(?<" + a.to_sym.to_s + ">.*)")
        m = match(r)
        return [true, m[a.to_sym]] unless m.nil?

        [false]
      end
    end

    class IContact
      attr_accessor :name, :type, :title, :email, :phones

      def initialize
        self.phones = []
      end

      def to_hash
        name = self.name || self.title || self.type
        name = self.title if name.blank?
        name = self.type if name.blank?

        {
          :name => name,
          :contact_type => self.type,
          :title => self.title,
          :email => self.email
        }
      end
    end

    class IPhone
      attr_accessor :type, :number

      def initialize t, n
        self.type, self.number = t, n
      end

      def to_hash
        {
          :phone_type => self.type,
          :number => self.number
        }
      end
    end

    class ICompany
      attr_accessor :name, :city, :zipcode, :website, :address1, :address2, :state,
        :email, :website, :phones, :country, :contacts, :external_id, :programs

      def initialize
        self.phones = []
        self.programs = []
      end

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

      def to_hash
        {
          :name => self.name,
          :city => self.city,
          :zipcode => self.zipcode,
          :website => self.website,
          :address1 => self.address1,
          :address2 => self.address2,
          :state => self.state,
          :email => self.email,
          :website => self.website,
          :country => self.country
        }
      end
    end

    class IProgram
      attr_accessor :external_id, :category, :type, :products, :trademarks, :notes, :contacts

      def initialize
        self.contacts = []
      end

      def to_hash
        category = self.category || "Unknown"
        category = "Unknown" if category.blank?

        {
          :program_type => self.type || "Unknown",
          :category => category,
          :products => self.products,
          :trademarks => self.trademarks,
          :notes => self.notes
        }
      end
    end

    def parseCompanyContacts text_data
      # "program contact" signals beginning of contacts
      # each contact is separated by an empty line
      contacts = []
      text_data.split(/\n /).each do |l|
        l.split("\n\n").each do |contact|
          unmatched = []
          c = IContact.new

          contact.split("\n").each do |row|
            # Skip empty lines
            next if row.strip.empty?

            # Try to match for specific type
           
            f = row.isAttribute? "Fax"
            if f.first
              c.phones.push IPhone.new "Fax", f.last.strip
              next
            end
            f = row.isAttribute? "Email"
            if f.first
              c.email = f.last.strip
              next
            end
            f = row.isAttribute? "Phone"
            if f.first
              c.phones.push IPhone.new "Phone", f.last.strip
              next
            end
            f = row.isAttribute? "Toll Free"
            if f.first
              c.phones.push IPhone.new "Toll Free", f.last.strip
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

      contacts.reject { |c| c.name.nil? and c.title.nil? and c.type.nil? }
    end

    def parseProgramContacts text_data
      # "program contact" signals beginning of contacts
      # each contact is separated by an empty line
      contacts = []
      text_data.split(/\n /).each do |l|
        l.split("\n\n").each do |contact|
          unmatched = []
          c = IContact.new
          c.phones = []

          contact.split("\n").each do |row|
            # Skip empty lines
            next if row.strip.empty?

            # Try to match for specific type
           
            f = row.isAttribute? "Fax"
            if f.first
              c.phones.push IPhone.new "Fax", f.last.strip
              next
            end
            f = row.isAttribute? "Email"
            if f.first
              c.email = f.last.strip
              next
            end
            f = row.isAttribute? "Phone"
            if f.first
              c.phones.push IPhone.new "Phone", f.last.strip
              next
            end
            f = row.isAttribute? "Toll Free"
            if f.first
              c.phones.push IPhone.new "Toll Free", f.last.strip
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

      contacts.reject { |c| c.name.nil? and c.title.nil? and c.type.nil? }
    end

    def getAttribute attribute, t
      t.match(Regexp.new("#{attribute}\n(?<#{attribute.downcase}>.*$)")) do |m|
        m[attribute.downcase.to_sym].split(";").collect { |p| p.strip }.join ", "
      end
    end

    def parseCompany row
      c = ICompany.new
      c.external_id = row[1].strip
      c.name = row[27].strip
      c.parseAddress row[6]
      c.city = row[3].strip
      c.zipcode = row[4].strip
      c.state = row[7].strip
      c.email = row[8].strip
      c.website = row[5].strip

      (11..26).reject { |i| i % 2 == 0 }.each do |i|
        unless row[i].eql? "NULL"
          c.phones.push IPhone.new row[i+1], row[i]
        end
      end

      c.contacts = parseCompanyContacts row[2].partition(/Personnel\nprogram contact/i).last

      c
    end

    def parseProgram row
      p = IProgram.new
      p.external_id = row[9].split("-").first
      p.category = row[2]

      # parse details
      p.type = getAttribute "Type", row[4]
      p.products = getAttribute "Products", row[4]
      p.trademarks = getAttribute "Trademarks", row[4]
      p.notes = row[4]

      # parse contacts
      p.contacts = parseProgramContacts p.notes.split("Personnel").last if p.notes.include? "Personnel"

      p
    end

    def readCompanies
      companies = []

      CSV.foreach(File.join(File.dirname(__FILE__), "salesverge_companies.csv")) do |row|
        next if row.last.eql? "company_name" #skip header row
        companies.push parseCompany row
      end

      companies
    end

    def readPrograms
      programs = []

      CSV.foreach(File.join(File.dirname(__FILE__), "salesverge_programs.csv")) do |row|
        next if row.last.eql? "updated_at"
        programs.push parseProgram row
      end

      programs
    end

    def sort1to9 a, b
      if a.external_id.to_i > b.external_id.to_i
        1
      elsif a.external_id.to_i == b.external_id.to_i
        0
      else
        -1
      end
    end

    def mergeCompaniesPrograms companies, programs
      programs.sort! { |a,b| sort1to9 a, b }
      companies.sort! { |a,b| sort1to9 a, b }

      companies.each do |co|
        co.programs = programs.select { |p| p.external_id == co.external_id }
      end

      companies
    end

    def createPhones array, parent
      array.reject! { |p| p.number.blank? or p.number.nil? }
      array.each do |phone|
        phone = parent.phones.create phone.to_hash
        phone.save!
      end
    end

    def createContacts array, parent
      array.each do |contact|
        contact = parent.contacts.create contact.to_hash
        contact.save!

        createPhones contact.phones, contact
      end
    end

    def pushData companies
      companies.each do |company|
        # Create the Company
        c = Company.new company.to_hash
        c.save!

        # Create Company Programs
        company.programs.each do |program|
          p = c.programs.create program.to_hash
          puts program.to_hash unless p.valid?
          p.save!

          # Create Program Contacts
          createContacts program.contacts, p
        end

        createContacts company.contacts, c
        createPhones company.phones, c
      end
    end

    companies = readCompanies
    programs = readPrograms
    companies = mergeCompaniesPrograms companies, programs

    pushData companies
  end
end
