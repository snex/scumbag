require 'tracery'
require 'mods-eng-basic'

include Tracery

def get_story(subject)
  grammar = createGrammar(
    victim: [
      'girl scout',
      'his own mother',
      'little old lady',
      'puppy'
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
      'smashed',
      'stole',
      'took'
    ],
    object_phys: [
      'bicycle',
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
      '#victim_verb# #victim.a#',
      '#verb_phys# #victim.a#\'s #object_phys#',
      '#verb_nonphys# #victim.a#\'s #object_nonphys#',
      'borrowed #victim.a#\'s #object_phys# and never gave it back'
    ],

    story: 'I heard $subject$ once #action#.'
  )
  grammar.addModifiers(Modifiers.baseEngModifiers)
  root = grammar.expand('#story#')
  return root.finishedText.gsub('$subject$', subject)
end
