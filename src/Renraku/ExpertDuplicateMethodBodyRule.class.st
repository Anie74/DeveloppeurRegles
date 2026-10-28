Class {
	#name : 'ExpertDuplicateMethodBodyRule',
	#superclass : 'ReExclusivelyExpertRule',
	#instVars : [
		'minimumStatements'
	],
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule class >> ruleName [
    ^ 'Méthodes potentiellement dupliquées'
]

{ #category : 'manifest' }
ExpertDuplicateMethodBodyRule class >> uniqueIdentifierName [
    ^ 'DuplicateMethodBody'
]

{ #category : 'checking' }
ExpertDuplicateMethodBodyRule >> checkClass: aClass [
    | groups |
    groups := Dictionary new.
    aClass methods do: [ :method |
        method ast body statements size >= minimumStatements ifTrue: [
            (groups
                at: (self fingerprintOfMethod: method)
                ifAbsentPut: [ OrderedCollection new ]) add: method ] ].
    ^ (groups values select: [ :each | each size > 1 ]) collect: [ :each |
        self
            newCritiqueFor: aClass
            hint: 'Méthodes potentiellement dupliquées : ',
                (', ' join: (each collect: [ :method | method selector asString ])) ]
]

{ #category : 'fingerprint' }
ExpertDuplicateMethodBodyRule >> collectNamesOf: aMethodNode into: aDictionary [
    aMethodNode arguments do: [ :each | self register: each name in: aDictionary ].
    aMethodNode nodesDo: [ :node |
        node isSequence ifTrue: [
            node temporaries do: [ :each | self register: each name in: aDictionary ] ].
        node isBlock ifTrue: [
            node arguments do: [ :each | self register: each name in: aDictionary ] ] ]
]

{ #category : 'fingerprint' }
ExpertDuplicateMethodBodyRule >> fingerprintOf: aNode names: aDictionary [
    | childrenText |
    aNode isVariable ifTrue: [
        ^ 'V:', (aDictionary at: aNode name ifAbsent: [ aNode name ]) ].
    aNode isLiteralNode ifTrue: [ ^ 'L:', aNode value printString ].
    childrenText := aNode children
        inject: ''
        into: [ :text :child |
            text, (self fingerprintOf: child names: aDictionary), ',' ].
    aNode isMessage ifTrue: [ ^ 'M:', aNode selector, '(', childrenText, ')' ].
    ^ aNode class name, '(', childrenText, ')'
]

{ #category : 'fingerprint' }
ExpertDuplicateMethodBodyRule >> fingerprintOfMethod: aMethod [
    | names |
    names := Dictionary new.
    self collectNamesOf: aMethod ast into: names.
    ^ aMethod numArgs printString, '|',
        (self fingerprintOf: aMethod ast body names: names)
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> group [
    ^ 'Maintenance'
]

{ #category : 'initialization' }
ExpertDuplicateMethodBodyRule >> initialize [
    super initialize.
    minimumStatements := 2
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> minimumStatements [
    ^ minimumStatements
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> minimumStatements: anInteger [
    minimumStatements := anInteger
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> name [
    ^ 'Méthodes potentiellement dupliquées'
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> rationale [
    ^ 'Deux méthodes de même structure indiquent du code dupliqué à factoriser'
]

{ #category : 'fingerprint' }
ExpertDuplicateMethodBodyRule >> register: aName in: aDictionary [
    aDictionary at: aName ifAbsentPut: [ 'v', (aDictionary size + 1) printString ]
]

{ #category : 'accessing' }
ExpertDuplicateMethodBodyRule >> severity [
    ^ #warning
]
