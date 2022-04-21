module Modifiers
  def self.get_pronoun(gender, type)
    return case gender
    when 'male'
      case type
      when 'sub'
        'he'
      when 'obj'
        'him'
      when 'pos'
        'his'
      else
        ''
      end
    when 'female'
      case type
      when 'sub'
        'she'
      when 'obj'
        'her'
      when 'pos'
        'her'
      else
        ''
      end
    else
      case type
      when 'sub'
        'they'
      when 'obj'
        'them'
      when 'pos'
        'their'
      else
        ''
      end
    end
  end

  def self.pronounModifiers
    {
      'pronoun' => lambda do |s, parameters|
        return get_pronoun(parameters[0], parameters[1])
      end
    }
  end
end
