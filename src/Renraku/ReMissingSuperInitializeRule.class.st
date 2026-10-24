"
Detect initialize method omission
"
Class {
	#name : 'ReMissingSuperInitializeRule',
	#superclass : 'ReExclusivelyIntermediateRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReMissingSuperInitializeRule class >> ruleName [
    ^ 'Appel manquant à super initialize'
]

{ #category : 'manifest' }
ReMissingSuperInitializeRule class >> uniqueIdentifierName [
    ^ 'MissingSuperInitialize'
]

{ #category : 'checking' }
ReMissingSuperInitializeRule >> checkMethod: aMethod [
    | callsSuper |
    aMethod selector = #initialize ifFalse: [ ^ #() ].
    callsSuper := false.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            node selector = #initialize and: [
                node receiver isVariable and: [ node receiver name = 'super' ] ] ])
            ifTrue: [ callsSuper := true ] ].
    callsSuper ifTrue: [ ^ #() ].
    ^ { self newCritiqueFor: aMethod hint: 'initialize doit appeler super initialize' }
]

{ #category : 'accessing' }
ReMissingSuperInitializeRule >> group [
    ^ 'Erreurs intermédiaire'


]

{ #category : 'testing' }
ReMissingSuperInitializeRule >> isAbstract [
    ^ self == ReExclusivelyIntermediateRule
]

{ #category : 'accessing' }
ReMissingSuperInitializeRule >> name [
    ^ 'Appel manquant à super initialize'


]

{ #category : 'accessing' }
ReMissingSuperInitializeRule >> rationale [
    ^ 'La méthode initialize doit appeler super initialize pour initialiser la chaîne d''héritage'


]

{ #category : 'accessing' }
ReMissingSuperInitializeRule >> severity [
    ^ #warning
]
