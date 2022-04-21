require 'tracery'
require 'mods-eng-basic'
require_relative 'possessive'
require_relative 'pronouns'

include Tracery


def get_story(scumbag, gender)
  grammar = createGrammar(
    indefinite_victim: File.readlines('./data/indefinite_victims.txt').map(&:chomp),
    definite_victim: File.readlines('./data/definite_victims.txt').map(&:chomp).map do |v|
      v.gsub('$pronoun$', "#.pronoun(#{gender},pos)#")
    end,
    victim: [
      '#definite_victim#',
      '#indefinite_victim.a#'
    ],

    victim_verb: File.readlines('./data/victim_verbs.txt').map(&:chomp),

    verb_phys: File.readlines('./data/physical_verbs.txt').map(&:chomp),
    verb_nonphys: File.readlines('./data/non_physical_verbs.txt').map(&:chomp),

    object_phys: File.readlines('./data/physical_objects.txt').map(&:chomp),
    object_nonphys: File.readlines('./data/non_physical_objects.txt').map(&:chomp),

    action: [
      '#victim_verb# #victim#',
      '#verb_phys# #victim.pos# #object_phys#',
      '#verb_nonphys# #victim.pos# #object_nonphys#',
      'borrowed #victim.pos# #object_phys# and never gave it back'
    ],

    story: 'I heard $scumbag$ once #action#.'
  )
  grammar.addModifiers(Modifiers.baseEngModifiers)
  grammar.addModifiers(Modifiers.possessiveModifiers)
  grammar.addModifiers(Modifiers.pronounModifiers)
  root = grammar.expand('#story#')
  return root.finishedText.gsub('$scumbag$', scumbag)
end
