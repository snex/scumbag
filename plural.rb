module Modifiers
  class << self
    
    alias_method :orig_pluralize, :pluralize

    def pluralize(s)
      return case s
      when 'child'
        return 'children'
      when 'life savings', 'lunch money'
        return s
      else
        orig_pluralize(s)
      end
    end
  end
end
