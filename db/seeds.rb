auth = Authentication.new()
inf = auth.getAuthInf(age:3600)
PlanRegister.create(
    email:"uiljpfs4fg5hsxzrnhknpdqfx@gmail.com",
    key:inf[:key],
    maxage:inf[:maxAge],
    session:inf[:session],
    name:"ひいらぎ"
)