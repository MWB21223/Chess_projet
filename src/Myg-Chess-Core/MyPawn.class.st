Class {
	#name : 'MyPawn',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'as yet unclassified' }
MyPawn >> diagonalCaptureSquares [
	"Retourne les cases diagonales capturables (uniquement si une pièce adverse s’y trouve).
	Ne gère pas la prise en passant."
	| diagLeft diagRight targets |
	targets := OrderedCollection new.

	diagLeft := self isWhite
		ifTrue: [ square up ifNotNil: #left ]
		ifFalse: [ square down ifNotNil: #left ].

	diagRight := self isWhite
		ifTrue: [ square up ifNotNil: #right ]
		ifFalse: [ square down ifNotNil: #right ].

	(diagLeft notNil and: [ diagLeft hasPiece and: [ diagLeft contents color ~= color ] ])
		ifTrue: [ targets add: diagLeft ].

	(diagRight notNil and: [ diagRight hasPiece and: [ diagRight contents color ~= color ] ])
		ifTrue: [ targets add: diagRight ].

	^ targets
]

{ #category : 'as yet unclassified' }
MyPawn >> enPassantTargetSquares [
	"Retourne la/les case(s) de prise en passant disponibles depuis la position actuelle.
	Le jeu (MyChessGame) doit exposer enPassantTargetSquare (une case ou nil)."
	| ep diagLeft diagRight targets |
	targets := OrderedCollection new.
	ep := self board game ifNotNil: #enPassantTargetSquare.
	ep isNil ifTrue: [ ^ targets ].

	"Les diagonales d’attaque du pion"
	diagLeft := self isWhite
		ifTrue: [ square up ifNotNil: #left ]
		ifFalse: [ square down ifNotNil: #left ].
	diagRight := self isWhite
		ifTrue: [ square up ifNotNil: #right ]
		ifFalse: [ square down ifNotNil: #right ].

	"En passant: on peut aller sur la case EP si elle est exactement l’une des diagonales"
	diagLeft = ep ifTrue: [ targets add: ep ].
	diagRight = ep ifTrue: [ targets add: ep ].

	^ targets
]

{ #category : 'as yet unclassified' }
MyPawn >> forwardMoveSquares [
	"Retourne les cases d'avancée (1 case si vide; 2 cases si sur rangée initiale
	et si la case à 1 case ET la case à 2 cases sont vides)."
	| targets forward one two |
	targets := OrderedCollection new.

	"Direction d’avancée (blanc vers #up, noir vers #down)"
	forward := self isWhite ifTrue: [ #up ] ifFalse: [ #down ].

	"1 case devant: doit être vide"
	one := square perform: forward.
	(one notNil and: [ one hasPiece not ]) ifTrue: [ targets add: one ].

	"2 cases depuis rangée initiale: les deux cases doivent être vides
	(convention locale: file = rangée 1–8)"
	(((self isWhite and: [ square file = $2 ])
		or: [ self isWhite not and: [ square file = $7 ] ])
		and: [ one notNil and: [ one hasPiece not ] ]) ifTrue: [
			two := one perform: forward.
			(two notNil and: [ two hasPiece not ]) ifTrue: [ targets add: two ] ].

	^ targets
]

{ #category : 'accessing' }
MyPawn >> id [

	^ 'P'
]

{ #category : 'rendering' }
MyPawn >> renderPieceOn: aSquare [ 
	
	^ aSquare renderPawn: self
]

{ #category : 'rendering' }
MyPawn >> targetSquaresLegal: aBoolean [
	"Compose les trois familles de mouvements: avance, capture diagonale, en passant."
	^ (self forwardMoveSquares),
	  (self diagonalCaptureSquares),
	  (self enPassantTargetSquares)
]
