module Examples.Optic.Records.Types where

  data Designation = Avenue
                   | Boulevard
                   | Circle
                   | Drive
                   | Street
                   | Way

  instance showDesignation :: Show Designation where
    show Avenue    = "Avenue"
    show Boulevard = "Boulevard"
    show Circle    = "Circle"
    show Drive     = "Drive"
    show Street    = "Street"
    show Way       = "Way"

  data State = AL
             | AK
             | AZ
             | AR
             | CA
             | CO
             | CT
             | DE
             | FL
             | GA
             | HI
             | ID
             | IL
             | IN
             | IA
             | KS
             | KY
             | LA
             | ME
             | MD
             | MA
             | MI
             | MN
             | MS
             | MO
             | MT
             | NE
             | NV
             | NH
             | NJ
             | NM
             | NY
             | NC
             | ND
             | OH
             | OK
             | OR
             | PA
             | RI
             | SC
             | SD
             | TN
             | TX
             | UT
             | VT
             | VA
             | WA
             | WV
             | WI
             | WY

  instance showState :: Show State where
    show AL = "AL"
    show AK = "AK"
    show AZ = "AZ"
    show AR = "AR"
    show CA = "CA"
    show CO = "CO"
    show CT = "CT"
    show DE = "DE"
    show FL = "FL"
    show GA = "GA"
    show HI = "HI"
    show ID = "ID"
    show IL = "IL"
    show IN = "IN"
    show IA = "IA"
    show KS = "KS"
    show KY = "KY"
    show LA = "LA"
    show ME = "ME"
    show MD = "MD"
    show MA = "MA"
    show MI = "MI"
    show MN = "MN"
    show MS = "MS"
    show MO = "MO"
    show MT = "MT"
    show NE = "NE"
    show NV = "NV"
    show NH = "NH"
    show NJ = "NJ"
    show NM = "NM"
    show NY = "NY"
    show NC = "NC"
    show ND = "ND"
    show OH = "OH"
    show OK = "OK"
    show OR = "OR"
    show PA = "PA"
    show RI = "RI"
    show SC = "SC"
    show SD = "SD"
    show TN = "TN"
    show TX = "TX"
    show UT = "UT"
    show VT = "VT"
    show VA = "VA"
    show WA = "WA"
    show WV = "WV"
    show WI = "WI"
    show WY = "WY"

module Examples.Optic.Records where

  import Examples.Optic.Records.Types

  import Optic.Core

  newtype Person = Person
    { firstName :: String
    , lastName  :: String
    , address   :: Address
    }

  newtype Address = Address
    { street :: StreetRec
    , city   :: String
    , state  :: State
    }

  newtype StreetRec = StreetRec
    { number      :: Number
    , streetName  :: String
    , designation :: Designation
    }

  runPerson (Person p) = p
  runAddress (Address a) = a
  runStreetRec (StreetRec s) = s

  instance showPerson :: Show Person where
    show (Person p) = "Person "
                   ++ "{firstName: " ++ show p.firstName
                   ++ ", lastName: " ++ show p.lastName
                   ++ ", address: " ++ show p.address
                   ++ "}"

  instance showAddress :: Show Address where
    show (Address a) = "Address "
                    ++ "{street: " ++ show a.street
                    ++ ", city: " ++ show a.city
                    ++ ", state: " ++ show a.state
                    ++ "}"

  instance showStreetRec :: Show StreetRec where
    show (StreetRec s) = "StreetRec "
                    ++ "{number: " ++ show s.number
                    ++ ", streetName: " ++ show s.streetName
                    ++ ", designation: " ++ show s.designation
                    ++ "}"

  johnDoe :: Person
  johnDoe = Person
    { firstName: "John"
    , lastName: "Doe"
    , address: Address
        { street: StreetRec
            { number: 1234
            , streetName: "Main"
            , designation: Street
            }
        , city: "AnyTown"
        , state: CA
        }
    }

  -- Updating fields without lenses.

  changeFirstName :: String -> Person -> Person
  changeFirstName newName (Person p) = Person p{firstName = newName}

  changeState :: State -> Person -> Person
  changeState newState (Person p) =
    Person p{address = Address (runAddress p.address){state = newState}}

  changeStreetNumber :: Number -> Person -> Person
  changeStreetNumber newNumber (Person p) =
    Person p{address = Address addr{street = StreetRec strt{number = newNumber}}}
    where
      addr = runAddress p.address
      strt = runStreetRec addr.street

  -- Updating fields with lenses.

  changeFirstNameLens :: String -> Person -> Person
  changeFirstNameLens = set (_Person..firstName)

  changeStateLens :: State -> Person -> Person
  changeStateLens = set (_Person..address.._Address..state)

  changeStreetNumberLens :: Number -> Person -> Person
  changeStreetNumberLens = set (_Person..address.._Address..street.._StreetRec..number)

  -- Getters and Setters.

  fullName :: Getter Person String
  fullName f p'@(Person p) = f (p.firstName ++ " " ++ p.lastName) <#> const p'

  -- Lenses

  _Person :: LensP _ _
  _Person f (Person b) = Person <$> f b

  _Address :: LensP _ _
  _Address f (Address b) = Address <$> f b

  _StreetRec :: LensP _ _
  _StreetRec f (StreetRec b) = StreetRec <$> f b

  firstName :: LensP _ _
  firstName f o = f o.firstName <#> \firstName' -> o{firstName = firstName'}

  lastName :: LensP _ _
  lastName f o = f o.lastName <#> \lastName' -> o{lastName = lastName'}

  address :: LensP _ _
  address f o = f o.address <#> \address' -> o{address = address'}

  street :: LensP _ _
  street f o = f o.street <#> \street' -> o{street = street'}

  city :: LensP _ _
  city f o = f o.city <#> \city' -> o{city = city'}

  state :: LensP _ _
  state f o = f o.state <#> \state' -> o{state = state'}

  number :: LensP _ _
  number f o = f o.number <#> \number' -> o{number = number'}

  streetName :: LensP _ _
  streetName f o = f o.streetName <#> \streetName' -> o{streetName = streetName'}

  designation :: LensP _ _
  designation f o = f o.designation <#> \designation' -> o{designation = designation'}

module Examples.Optic.Bounded where

  import Optic.Core

  newtype Ball = Ball
    { x :: Number
    , y :: Number
    }

  instance showBall :: Show Ball where
    show (Ball b) = "Ball {x: " ++ show b.x ++ ", y:" ++ show b.y ++ "}"

  minX = 0
  minY = 0
  maxX = 100
  maxY = 100

  type LowerBound = Number
  type UpperBound = Number

  clamp :: LowerBound -> UpperBound -> Number -> Number
  clamp low high n = if n < low then low else if n > high then high else n

  _Ball :: LensP _ _
  _Ball f (Ball b) = Ball <$> f b

  x :: LensP _ _
  x f o = f o.x <#> \x' -> o{x = clamp minX maxX x'}

  y :: LensP _ _
  y f o = f o.y <#> \y' -> o{y = clamp minY maxY y'}

  ball = Ball {x: 50, y: 50}

module Examples.Optic.Virtual where

  import Optic.Core

  type MM = Number
  type CM = Number
  type M = Number
  type In = Number
  type Ft = Number

  newtype Length = Length MM

  instance showLength :: Show Length where
    show (Length n) = "Length (" ++ show n ++ ")"

  tenmm :: Length
  tenmm = Length 10

  _Length :: LensP _ _
  _Length f (Length n) = Length <$> f n

  mm :: LensP Length MM
  mm f (Length n) = f n <#> \n' -> Length n'

  cm :: LensP Length CM
  cm f (Length n) = f (n / 10) <#> \n' -> Length (n' * 10)

  m :: LensP Length M
  m f (Length n) = f (n / 1000) <#> \n' -> Length (n' * 1000)

  inches :: LensP Length In
  inches f (Length n) = f (n / 25.4) <#> \n' -> Length (n' * 25.4)

  feet :: LensP Length Ft
  feet f (Length n) = f (n / 304.8) <#> \n' -> Length (n' * 304.8)

module Examples.Optic.Traversal where

  import Data.Either (Either(..))
  import Data.Maybe (Maybe(..))
  import Data.String (length)
  import Data.Tuple (Tuple(..))

  import Optic.Index
  import Optic.Core
  import Optic.Extended
  import Optic.Refractor.Lens
  import Optic.Refractor.Prism

  foo :: [Tuple (Either Number (Maybe String)) (Maybe Boolean)]
  foo =
    [ Tuple (Left 1) Nothing
    , Tuple (Left 2) (Just true)
    , Tuple (Right (Just "three")) (Just true)
    , Tuple (Right (Just "four")) (Just false)
    , Tuple (Right Nothing) Nothing
    ]

  bar = foo # mapped.._1.._Right.._Just ++~ " wat"
  baz = foo # mapped.._1.._Left *~ 5
  quux = foo # mapped.._2.._Just %~ (\b -> if b then "yes" else "nope")
  wibble = foo # mapped.._1.._Right.._Just %~ length
  wobble = foo # ix 1 .~ wat
  wubble = foo # ix 100 .~ wat

  wat :: Tuple (Either Number (Maybe String)) (Maybe Boolean)
  wat = Tuple (Left 12) (Nothing)