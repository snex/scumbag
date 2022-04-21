require 'tracery'
require 'mods-eng-basic'
require_relative 'possessive'
require_relative 'pronouns'

include Tracery


def get_story(scumbag, gender)
  grammar = createGrammar(
    indefinite_victim: [
      'girl scout',
      'little old lady',
      'puppy'
    ],
    definite_victim: [
      "#.pronoun(#{gender},pos)# own mother",
    ],
    victim: [
      '#definite_victim#',
      '#indefinite_victim.a#'
    ],

    victim_verb: [
      'kicked',
      'punched',
      'scammed',
      'shoved',
      'stole from'
    ],

    verb_phys: [
      'broke',
      'keyed',
      'smashed',
      'stole',
      'took'
    ],
    object_phys: [
      'bicycle',
      'car',
      'lunch money'
    ],

    verb_nonphys: [
      'disliked',
      'insulted',
      'wrote a disparaging Tweet about'
    ],
    object_nonphys: [
      'physical deformity',
      'YouTube video'
    ],

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
