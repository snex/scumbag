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
    collection: File.readlines('./data/collections.txt').map(&:chomp),
    pathetic_adjective: File.readlines('./data/pathetic_adjectives.txt').map(&:chomp),

    indefinite_victim: File.readlines('./data/indefinite_victims.txt').map(&:chomp),
    definite_victim: File.readlines('./data/definite_victims.txt').map(&:chomp).map do |v|
      v.gsub('$pronoun$', "#.pronoun(#{gender},pos)#")
    end,

    victim: [
      '#definite_victim#',
      '#indefinite_victim.a#',
      '#pathetic_adjective.a# #indefinite_victim#',
      '#collection.a# full of #indefinite_victim.s#',
      '#collection.a# full of #pathetic_adjective# #indefinite_victim.s#'
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

    story: "I heard #{scumbag} once #action#."
  )
  grammar.addModifiers(Modifiers.baseEngModifiers)
  grammar.addModifiers(Modifiers.possessiveModifiers)
  grammar.addModifiers(Modifiers.pronounModifiers)
  root = grammar.expand('#story#')

  return root.finishedText
end
