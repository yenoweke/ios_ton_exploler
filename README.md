# iOS Application to explore Ton blockchain

## Simple Ton explorer with filters

Donate to support\
💎 TON: EQCjoMgPIVwOX0H5sJTdKexlVSjB4czgNkAOeRJ5UnDGULg5

Create files:\
`xcconfigs/Debug.xcconfig`\
`xcconfigs/Release.xcconfig`
```
TONCENTER_API_KEY = <API_KEY>
CODE_SIGN_ENTITLEMENTS = Resources/TonTransactions-<Debug or Release>.entitlements
TT_BACKEND_URL = <BACKEND URL>
```

# Gettings started

install tuist
install swiftgen

create folder `xcconfg`, and files `Debug.xcconfig`, `Release.xcconfg`

run in root folder
`tuist fetch`
`tuist generate`