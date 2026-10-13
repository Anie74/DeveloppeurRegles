"
Detect ifTrue and ifFalse as well 2 points.
"
Class {
	#name : 'ReIfTrueColonRule',
	#superclass : 'ReExclusivelyBeginnersRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'manifest' }
ReIfTrueColonRule class >> ruleName [ 
    ^ 'IfTrueColon'
]

{ #category : 'checking' }
ReIfTrueColonRule >> checkMethod: aMethod [
    | critiques sourceCode |
    critiques := OrderedCollection new.
    sourceCode := aMethod sourceCode.

    (sourceCode includesSubstring: 'ifTrue[') ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: 'ifTrue[ doit être écrit ifTrue: [';
            yourself) ].

    (sourceCode includesSubstring: 'ifFalse[') ifTrue: [
        critiques add: ((ReTrivialCritique for: aMethod by: self)
            tinyHint: 'ifFalse[ doit être écrit ifFalse: [';
            yourself) ].

    ^ critiques
]

{ #category : 'accessing' }
ReIfTrueColonRule >> group [
    ^ 'Erreurs débutant'
]

{ #category : 'accessing' }
ReIfTrueColonRule >> name [
    ^ 'ifTrue/ifFalse require 2 points (:)'
]

{ #category : 'accessing' }
ReIfTrueColonRule >> rationale [
    ^ 'Messages ifTrue: and ifFalse: requires two points : before a bloc'
]

{ #category : 'accessing' }
ReIfTrueColonRule >> severity [
    ^ #error
]
