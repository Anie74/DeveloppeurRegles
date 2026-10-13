"
Classify noobs developper
"
Class {
	#name : 'Noob',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
Noob class >> ruleName [ 
    ^ 'NoobRule'
]

{ #category : 'checking' }
Noob >> checkMethod: aMethod [
    | critiques sourceCode |
    critiques := OrderedCollection new.
    sourceCode := aMethod sourceCode.

    { 'True' -> 'true'. 'False' -> 'false'. 'Nil' -> 'nil'. 'Self' -> 'self' }
        do: [ :aForm |
            self detectWord: aForm in: sourceCode for: aMethod critiques: critiques ].

    (self includesWord: 'return' in: sourceCode) ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Utilisez ^ au lieu de return';
            yourself) ].

    { 'ifTrue[' -> 'ifTrue: ['. 'ifFalse[' -> 'ifFalse: ['. '&&' -> 'and:'. '||' -> 'or:' }
        do: [ :aForm |
            self detectPattern: aForm in: sourceCode for: aMethod critiques: critiques ].

    ^ critiques
]

{ #category : 'private' }
Noob >> detectPattern: aForm in: sourceCode for: aMethod critiques: critiques [
    (sourceCode includesSubstring: aForm key) ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: 'Utilisez ', aForm value, ' au lieu de ', aForm key;
            yourself) ]
]

{ #category : 'private' }
Noob >> detectWord: aForm in: sourceCode for: aMethod critiques: critiques [
    (self includesWord: aForm key in: sourceCode) ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: aForm key, ' doit être écrit ', aForm value, ' (minuscules)';
            yourself) ]

]

{ #category : 'accessing' }
Noob >> group [
    ^ 'Noobs Errors'
]

{ #category : 'accessing' }
Noob >> name [
    ^ 'Cuurrent noobs Errors'
]

{ #category : 'accessing' }
Noob >> rationale [
    ^ 'Detect noobs syntax errors'
]

{ #category : 'accessing' }
Noob >> severity [
    ^ #error
]
