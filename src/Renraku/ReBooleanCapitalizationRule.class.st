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
    ^ 'Noobs Errors'
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> name [
    ^ 'Booleans bad capitalized'
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> rationale [
    ^ 'In Pharo, booleans and nil must be written in lowercase: true, false, nil'
]

{ #category : 'accessing' }
ReBooleanCapitalizationRule >> severity [
    ^ #error
]
