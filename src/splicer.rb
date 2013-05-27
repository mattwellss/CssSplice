module CssSplicer
  class Splicer
    attr_reader :name
    @@input_parsers = []

    def initialize(name, allowed=[])
      @name = name
      @declarations = {}
      @allowed_properties = []
      add_allowed_properties!(allowed)
    end



    def self.input_parsers
      @@input_parsers
    end

    def self.input_parsers=(item)
      @@input_parsers.push(item)
    end
    
    def add_allowed_properties!(allowed)
      @allowed_properties.concat(allowed).uniq!
    end

    def add_valid_rules!(cssDoc)
      matches = {}
      cssDoc.each_selector do |selector, declaration, specificity|
        combined_rules = []
        declaration.split(';').each do |rule|

          if index = @allowed_properties.find_index(rule.split(':').shift.strip)
            combined_rules.push(rule.strip)
          end
        end
        unless combined_rules.empty?
          matches[selector.to_sym] = combined_rules
        end
      end
      @declarations.merge!(matches)
    end

    def to_s
      r = []
      @declarations.each do |selector, decl|
        r.push("#{selector} { #{decl.join("; ")}; }")
      end
      return r.join("\n")
    end

  end
end
