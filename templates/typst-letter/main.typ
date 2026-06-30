#import "@preview/letter-pro:3.0.0": letter-simple
#import "@preview/ez-today:2.1.0"


#set text(lang: "de")

#show: letter-simple.with(
  sender: (
    name: "Max Mustermann",
    address: "Willy-Brandt-Straße 1, 10557 Berlin",
    extra: [
      Telefon: #link("tel:+49tel")[+49 tel]\
      E-Mail: #link("mailto:test@example.com")[test\@example.com]\
    ],
  ),

  annotations: [Einschreiben - Rückschein],
  recipient: [
    Finanzamt Frankfurt\
    Einkommenssteuerstelle\
    Gutleutstraße 5\
    60329 Frankfurt
  ],

  reference-signs: (
    ([Steuernummer], [333/24692/5775]),
  ),

  date: [#ez-today.today()],
  subject: "Subject or sth",
)

Sehr geehrte Damen und Herren,


Mit freundlichen Grüßen
#v(1cm)
Name

#v(1fr)
*Anlagen:*
- Rechnung
