Class {
	#name : 'ExpertPublicMethodDocumentationRule',
	#superclass : 'ReExclusivelyExpertRule',
	#instVars : [
		'exemptedProtocols',
		'minimumStatements'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule class >> ruleName [
    ^ 'Méthode publique sans documentation'
]

{ #category : 'manifest' }
ExpertPublicMethodDocumentationRule class >> uniqueIdentifierName [
    ^ 'PublicMethodDocumentation'
]

{ #category : 'checking' }
ExpertPublicMethodDocumentationRule >> checkMethod: aMethod [
    (self isPublic: aMethod) ifFalse: [ ^ #() ].
    aMethod ast body statements size < minimumStatements ifTrue: [ ^ #() ].
    (self hasComment: aMethod) ifTrue: [ ^ #() ].
    ^ { self
        newCritiqueFor: aMethod
        hint: 'Méthode publique sans commentaire : documentez son rôle' }
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> exemptedProtocols [
    ^ exemptedProtocols
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> exemptedProtocols: aCollection [
    exemptedProtocols := aCollection
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> group [
    ^ 'Maintenance'
]

{ #category : 'private' }
ExpertPublicMethodDocumentationRule >> hasComment: aMethod [
    aMethod ast nodesDo: [ :node |
        (node comments ifNil: [ #() ]) isEmpty ifFalse: [ ^ true ] ].
    ^ false
]

{ #category : 'initialization' }
ExpertPublicMethodDocumentationRule >> initialize [
    super initialize.
    exemptedProtocols := #(#private #initialization).
    minimumStatements := 2
]

{ #category : 'private' }
ExpertPublicMethodDocumentationRule >> isPublic: aMethod [
    ^ (exemptedProtocols includes: aMethod protocolName asSymbol) not
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> minimumStatements [
    ^ minimumStatements
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> minimumStatements: anInteger [
    minimumStatements := anInteger
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> name [
    ^ 'Méthode publique sans documentation'
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> rationale [
    ^ 'Une méthode publique non triviale doit être documentée par un commentaire, selon la convention du projet'
]

{ #category : 'accessing' }
ExpertPublicMethodDocumentationRule >> severity [
    ^ #warning
]
