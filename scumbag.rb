require 'tracery'
require 'mods-eng-basic'
require_relative 'plural'
require_relative 'possessive'
require_relative 'pronouns'

include Tracery

def load_file(filename)
  File.readlines("./data/#{filename}.txt").map(&:chomp).reject do |line|
    line[0] == '#'
  end
end

def get_story(scumbag, gender)
  grammar = createGrammar(
    collection:         load_file('collections'),
    pathetic_adjective: load_file('pathetic_adjectives'),

    indefinite_victim: load_file('indefinite_victims'),
    definite_victim:   load_file('definite_victims').map do |v|
      v.gsub('$pronoun$', "#.pronoun(#{gender},pos)#")
    end,

    victim: [
      '#definite_victim#',
      '#indefinite_victim.a#',
      '#pathetic_adjective.a# #indefinite_victim#'
    ],
    victim_collection: [
      '#collection.a# full of #indefinite_victim.s#',
      '#collection.a# full of #pathetic_adjective# #indefinite_victim.s#'
    ],
    indifferent_victim: [
      '#victim#', '#victim_collection#'
    ],

    victim_verb: load_file('victim_verbs'),

    verb_phys:    load_file('physical_verbs'),
    verb_nonphys: load_file('non_physical_verbs'),

    object_phys:    load_file('physical_objects'),
    object_nonphys: load_file('non_physical_objects'),

    singular_transitive_action: [
      '#verb_phys# #victim.pos# #object_phys#',
      '#verb_nonphys# #victim.pos# #object_nonphys#'
    ],
    plural_transitive_action: [
      '#verb_phys# #victim.pos# #object_phys.s#',
      '#verb_nonphys# #victim.pos# #object_nonphys.s#'
    ],
    transitive_action: [
      '#singular_transitive_action#',
      '#plural_transitive_action#'
    ],

    action: [
      '#victim_verb# #indifferent_victim#',

      '#transitive_action#',

      'borrowed #victim.pos# #object_phys# and never gave it back',
      'borrowed #victim_collection.pos# #object_phys.s# and never gave them back',

      "promised to buy #{rand(10..100)} #object_phys.s# from #indifferent_victim# but then never paid"
    ],

    story: "I heard #{scumbag} once #action#."
  )
  grammar.addModifiers(Modifiers.baseEngModifiers)
  grammar.addModifiers(Modifiers.possessiveModifiers)
  grammar.addModifiers(Modifiers.pronounModifiers)
  root = grammar.expand('#story#')

  return root.finishedText
end
