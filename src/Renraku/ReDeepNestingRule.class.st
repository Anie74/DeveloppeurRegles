Class {
	#name : 'ReDeepNestingRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReDeepNestingRule class >> ruleName [
    ^ 'Imbrication trop profonde'
]

{ #category : 'manifest' }
ReDeepNestingRule class >> uniqueIdentifierName [
    ^ 'DeepNesting'
]

{ #category : 'checking' }
ReDeepNestingRule >> checkMethod: aMethod [
    | depth |
    depth := self depthOf: aMethod ast.
    depth > self maxDepth ifTrue: [
        ^ { self
            newCritiqueFor: aMethod
            hint: 'Imbrication sur ', depth printString, ' niveaux (maximum ',
                self maxDepth printString, ') : extrayez des méthodes' } ].
    ^ #()
]

{ #category : 'private' }
ReDeepNestingRule >> depthOf: aNode [
    | deepest |
    deepest := aNode children
        inject: 0
        into: [ :max :child | max max: (self depthOf: child) ].
    ^ aNode isBlock
        ifTrue: [ deepest + 1 ]
        ifFalse: [ deepest ]
]

{ #category : 'accessing' }
ReDeepNestingRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReDeepNestingRule >> maxDepth [
    ^ 3
]

{ #category : 'accessing' }
ReDeepNestingRule >> name [
    ^ 'Imbrication trop profonde'
]

{ #category : 'accessing' }
ReDeepNestingRule >> rationale [
    ^ 'Une imbrication de plus de 3 blocs rend le code difficile à lire : extrayez des méthodes'
]

{ #category : 'accessing' }
ReDeepNestingRule >> severity [
    ^ #warning
]
