Class {
	#name : 'ReArgumentModificationRule',
	#superclass : 'ReExclusivelyExpertRule',
	#category : 'Renraku-Rules',
	#package : 'Renraku',
	#tag : 'Rules'
}

{ #category : 'accessing' }
ReArgumentModificationRule class >> ruleName [
    ^ 'Modification d''un argument'
]

{ #category : 'manifest' }
ReArgumentModificationRule class >> uniqueIdentifierName [
    ^ 'ArgumentModification'
]

{ #category : 'checking' }
ReArgumentModificationRule >> checkMethod: aMethod [
    | argumentNames critiques |
    argumentNames := aMethod ast arguments collect: [ :each | each name ].
    argumentNames isEmpty ifTrue: [ ^ #() ].
    critiques := OrderedCollection new.
    aMethod ast nodesDo: [ :node |
        (node isMessage and: [
            (self mutatingSelectors includes: node selector) and: [
                node receiver isVariable and: [
                    argumentNames includes: node receiver name ] ] ])
            ifTrue: [
                critiques add: (self
                    newCritiqueFor: aMethod
                    hint: 'L''argument ', node receiver name,
                        ' est modifié : travaillez sur une copie') ] ].
    ^ critiques
]

{ #category : 'accessing' }
ReArgumentModificationRule >> group [
    ^ 'Conception avancée'
]

{ #category : 'accessing' }
ReArgumentModificationRule >> mutatingSelectors [
    ^ #(#add: #addAll: #addFirst: #addLast: #remove: #removeAll: #removeKey:
        #removeFirst #removeLast #at:put: #sort #sort:)
]

{ #category : 'accessing' }
ReArgumentModificationRule >> name [
    ^ 'Modification d''un argument'
]

{ #category : 'accessing' }
ReArgumentModificationRule >> rationale [
    ^ 'Modifier un argument crée un effet de bord inattendu pour l''appelant : travaillez sur une copie'
]

{ #category : 'accessing' }
ReArgumentModificationRule >> severity [
    ^ #warning
]
