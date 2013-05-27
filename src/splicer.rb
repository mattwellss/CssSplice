module CssSplicer
  class Splicer
    attr_reader :name
    @@input_parsers = []

    def initialize(name, allowed=nil)
      @name = name
      @allowed_properties = allowed
      @declarations = {}
    end

    def self.input_parsers
      @@input_parsers
    end

    def self.input_parsers=(item)
      @@input_parsers.push(item)
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
        r.push("#{selector} {\n\t#{decl.join(";\n\t")} }")
      end
      return r.join("\n")
    end

  end
end
