"
`do:` dont le bloc ne fait qu'un `add:` : c'est un `collect:` mal écrit.
"
Class {
	#name : 'ReDoInsteadOfCollectRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReDoInsteadOfCollectRule class >> ruleName [
    ^ 'do: avec add: au lieu de collect:'
]

{ #category : 'manifest' }
ReDoInsteadOfCollectRule class >> uniqueIdentifierName [
    ^ 'DoInsteadOfCollect'
]

{ #category : 'checking' }
ReDoInsteadOfCollectRule >> checkMethod: aMethod [
    | critiques |
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            node selector = #do: and: [ node arguments first isBlock ] ])
            ifTrue: [
                | statements |
                statements := node arguments first body statements.
                (statements size = 1 and: [
                    statements first isMessage and: [
                        statements first selector = #add: ] ])
                    ifTrue: [
                        critiques add: (self
                            newCritiqueFor: aMethod
                            hint: 'Use collect: instead of do: with add:') ] ] ].
    ^ critiques

]

{ #category : 'accessing' }
ReDoInsteadOfCollectRule >> group [
    ^ 'Intermediate errors rule'
]

{ #category : 'accessing' }
ReDoInsteadOfCollectRule >> name [
    ^ 'do: avec add: au lieu de collect:'
]

{ #category : 'accessing' }
ReDoInsteadOfCollectRule >> rationale [
    ^ 'Pour construire une collection à partir d''une autre, utilisez collect: plutôt que do: avec add:'

]

{ #category : 'accessing' }
ReDoInsteadOfCollectRule >> severity [
    ^ #warning
]
