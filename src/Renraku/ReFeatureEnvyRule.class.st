Class {
	#name : 'ReFeatureEnvyRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReFeatureEnvyRule class >> ruleName [
    ^ 'Feature envy'
]

{ #category : 'manifest' }
ReFeatureEnvyRule class >> uniqueIdentifierName [
    ^ 'FeatureEnvy'
]

{ #category : 'checking' }
ReFeatureEnvyRule >> checkMethod: aMethod [
    | argumentNames selfCount counts |
    argumentNames := aMethod ast arguments collect: [ :each | each name ].
    argumentNames isEmpty ifTrue: [ ^ #() ].
    selfCount := 0.
    counts := Dictionary new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [ node receiver isVariable ]) ifTrue: [
            node receiver name = 'self'
                ifTrue: [ selfCount := selfCount + 1 ]
                ifFalse: [
                    (argumentNames includes: node receiver name) ifTrue: [
                        counts
                            at: node receiver name
                            put: (counts at: node receiver name ifAbsent: [ 0 ]) + 1 ] ] ] ].
    ^ (counts associations select: [ :each |
            each value >= self minimumSends and: [ each value > (selfCount * 2) ] ])
        collect: [ :each |
            self
                newCritiqueFor: aMethod
                hint: 'Feature envy : ', each value printString,
                    ' messages envoyés à ', each key, ' : déplacez cette logique dans sa classe' ]
]

{ #category : 'accessing' }
ReFeatureEnvyRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReFeatureEnvyRule >> minimumSends [
    ^ 5
]

{ #category : 'accessing' }
ReFeatureEnvyRule >> name [
    ^ 'Feature envy'
]

{ #category : 'accessing' }
ReFeatureEnvyRule >> rationale [
    ^ 'Une méthode qui utilise surtout les services d''un argument devrait être déplacée dans la classe de cet argument'
]

{ #category : 'accessing' }
ReFeatureEnvyRule >> severity [
    ^ #warning
]
