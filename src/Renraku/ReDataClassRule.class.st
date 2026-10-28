Class {
	#name : 'ReDataClassRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReDataClassRule class >> ruleName [
    ^ 'Classe de données'
]

{ #category : 'manifest' }
ReDataClassRule class >> uniqueIdentifierName [
    ^ 'DataClass'
]

{ #category : 'checking' }
ReDataClassRule >> checkClass: aClass [
    | methods trivial |
    methods := aClass methods.
    methods size < self minimumMethods ifTrue: [ ^ #() ].
    trivial := methods count: [ :each | self isTrivialAccessor: each ].
    (trivial / methods size) >= (7 / 10) ifTrue: [
        ^ { self
            newCritiqueFor: aClass
            hint: trivial printString, ' accesseurs sur ', methods size printString,
                ' méthodes : ajoutez du comportement ou fusionnez cette classe' } ].
    ^ #()
]

{ #category : 'accessing' }
ReDataClassRule >> group [
    ^ 'Architecture'
]

{ #category : 'private' }
ReDataClassRule >> isTrivialAccessor: aMethod [
    | statements statement names |
    statements := aMethod ast body statements.
    statements size = 1 ifFalse: [ ^ false ].
    statement := statements first.
    names := aMethod methodClass instVarNames collect: [ :each | each asSymbol ].
    (statement isReturn and: [ statement value isVariable ])
        ifTrue: [ ^ names includes: statement value name asSymbol ].
    (statement isAssignment and: [ statement value isVariable ])
        ifTrue: [ ^ names includes: statement variable name asSymbol ].
    ^ false
]

{ #category : 'accessing' }
ReDataClassRule >> minimumMethods [
    ^ 4
]

{ #category : 'accessing' }
ReDataClassRule >> name [
    ^ 'Classe de données'
]

{ #category : 'accessing' }
ReDataClassRule >> rationale [
    ^ 'Une classe presque uniquement composée d''accesseurs n''a pas de comportement : la logique qui la manipule est ailleurs'
]

{ #category : 'accessing' }
ReDataClassRule >> severity [
    ^ #warning
]
