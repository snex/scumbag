module Modifiers
  def self.possessiveModifiers
    {
      'pos' => lambda do |s, parameters|
        if s[-1] == 's'
          return "#{s}'"
        else
          return "#{s}'s"
        end
      end
    }
  end
end
