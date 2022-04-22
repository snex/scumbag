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
    unsourced_start:  load_file('unsourced_starts'),
    sourced_start:    load_file('sourced_starts'),
    reputable_source: load_file('reputable_sources'),

    unsourced_story_start: [
      '#unsourced_start#',
      '#unsourced_start# that'
    ],
    story_start: [
      '#unsourced_story_start#',
      '#sourced_start# #reputable_source# that',
    ],

    collection:         load_file('collections'),
    pathetic_adjective: load_file('pathetic_adjectives'),

    bad_guy:            load_file('bad_guys'),
    friendly_verb:      load_file('friendly_verbs').map do |v|
      v.gsub('$pronoun$', "#.pronoun(#{gender},sub)#")
    end,

    bad_thing: load_file('bad_things'),

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
      '#victim#',
      '#victim_collection#'
    ],

    modifiable_victim_verb:   load_file('modifiable_victim_verbs'),
    unmodifiable_victim_verb: load_file('unmodifiable_victim_verbs'),
    victim_verb_modifier:     load_file('victim_verb_modifiers'),

    intransitive_action: [
      '#modifiable_victim_verb# #indifferent_victim# #victim_verb_modifier#',
      '#modifiable_victim_verb# #indifferent_victim#',
      '#unmodifiable_victim_verb# #indifferent_victim#',
      'made #indifferent_victim# cry',
    ],

    verb_phys:    load_file('physical_verbs'),
    verb_nonphys: load_file('non_physical_verbs'),

    object_phys:    load_file('physical_objects'),
    object_nonphys: load_file('non_physical_objects'),

    singular_transitive_action: [
      '#verb_phys# #victim.pos# #object_phys#',
      '#verb_nonphys# #victim.pos# #object_nonphys#'
    ],
    plural_transitive_action: [
      '#verb_phys# #indifferent_victim.pos# #object_phys.s#',
      '#verb_nonphys# #indifferent_victim.pos# #object_nonphys.s#'
    ],
    transitive_action: [
      '#singular_transitive_action#',
      '#plural_transitive_action#'
    ],

    borrowed_action: [
      'borrowed #victim.pos# #object_phys# and never gave it back',
      'borrowed #victim_collection.pos# #object_phys.s# and never gave them back'
    ],

    action: [
      '#intransitive_action#',
      '#transitive_action#',
      '#borrowed_action#',
      "promised to buy #{rand(10..100)} #object_phys.s# from #indifferent_victim# but then never paid",
      '#friendly_verb# #bad_guy#',
      'tried to sell #bad_thing# to #indifferent_victim#'
    ],

    story: "#story_start# #{scumbag} #action#."
  )
  grammar.addModifiers(Modifiers.baseEngModifiers)
  grammar.addModifiers(Modifiers.possessiveModifiers)
  grammar.addModifiers(Modifiers.pronounModifiers)
  root = grammar.expand('#story#')

  return root.finishedText
end
