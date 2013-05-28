module CssSplicer
  class Splicer
    attr_accessor :combine_rules, :combine_selectors
    attr_reader :name
    @@input_parsers = []

    def initialize(name)
      @name = name
      @declarations = {}
      @allowed_properties = []
      @combine_rules = false
      @combine_selectors = false
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
        rules = []
        declaration.split(';').each do |rule|

          if index = @allowed_properties.find_index(rule.split(':').shift.strip)
            rules.push(rule.strip)
          end

        end
          
        unless rules.empty?
          add_declaration!(selector, rules)
        end
      end
    end

    def add_declaration!(selector, rules)
      if @combine_selectors and res = @declarations.rassoc(rules)
        @declarations["#{res[0].to_s}, #{selector}".to_sym] = rules
        @declarations.delete(res[0])
      else
        @declarations[selector.to_sym] = rules
      end
    end


    def get_block_text(selector, decl)
      if @combine_rules
        return "#{selector} { #{decl.join("; ")}; }"
      else
        return decl.map { |rule| "#{selector} { #{rule}; }" }.join("\n")
      end
    end


    def to_s
      r = []
      @declarations.each do |selector, decl|
        r.push(get_block_text(selector, decl))
      end
      return r.join("\n")
    end

  end
end
