module Modifiers
  class << self
    
    alias_method :orig_pluralize, :pluralize

    def pluralize(s)
      if s == 'child'
        return 'children'
      end
      if s == 'life savings'
        return s
      end

      orig_pluralize(s)
    end
  end
end
