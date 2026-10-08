"
Detect booleans and nil capitalization error
"
Class {
	#name : 'ReBooleanCapitalizationRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReBooleanCapitalizationRule class >> ruleName [
^ 'Boolean Capitalization'
]

{ #category : 'checking' }
ReBooleanCapitalizationRule >> checkMethod: aMethod [
    | critiques sourceCode |
    critiques := OrderedCollection new.
    sourceCode := aMethod sourceCode.

    self detectBoolean: 'True' -> 'true' in: sourceCode for: aMethod critiques: critiques.
    self detectBoolean: 'False' -> 'false' in: sourceCode for: aMethod critiques: critiques.
    self detectBoolean: 'Nil' -> 'nil' in: sourceCode for: aMethod critiques: critiques.

    ^ critiques
]

{ #category : 'private' }
ReBooleanCapitalizationRule >> detectBoolean: aForm in: sourceCode for: aMethod critiques: critiques [
    (self includesWord: aForm key in: sourceCode) ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: aForm key, ' doit être écrit ', aForm value, ' (minuscules)';
            yourself) ]
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> group [
    ^ 'Erreurs débutant'
]

{ #category : 'private' }
ReBooleanCapitalizationRule >> includesWord: aWord in: sourceCode [
    | start index before after |
    start := 1.
    [ index := sourceCode indexOfSubCollection: aWord startingAt: start.
      index > 0 ] whileTrue: [
        before := index > 1
            ifTrue: [ sourceCode at: index - 1 ]
            ifFalse: [ Character space ].
        after := (index + aWord size) <= sourceCode size
            ifTrue: [ sourceCode at: index + aWord size ]
            ifFalse: [ Character space ].
        (before isAlphaNumeric or: [ after isAlphaNumeric ])
            ifFalse: [ ^ true ].
        start := index + 1 ].
    ^ false
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> name [
    ^ 'Booléens mal capitalisés'
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> rationale [
    ^ 'En Pharo, les booléens et nil doivent être écrits en minuscules: true, false, nil'
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> severity [
    ^ #error
]
