from sqlalchemy import create_engine, text

DATABASE_URL = (
    "mssql+pyodbc://localhost/bokhandel"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)

engine = create_engine(DATABASE_URL)


def search_books(my_book):
    query = text("""
        SELECT
            b.Titel          AS titel,
            f.Förnamn + ' ' + f.Efternamn AS forfattare,
            s.Namn           AS butik,
            l.Antal          AS antal_exemplar
        FROM dbo.Böcker AS b
        INNER JOIN dbo.Författare AS f  ON f.FörfattareID = b.FörfattareID
        INNER JOIN dbo.LagerSaldo AS l  ON l.ISBN13       = b.ISBN13
        INNER JOIN dbo.Butiker    AS s  ON s.ButikID      = l.ButikID
        WHERE b.Titel LIKE :my_book
        ORDER BY b.Titel, s.Namn
    """)

    with engine.connect() as conn:
        result = conn.execute(query, {"my_book": f"%{my_book}%"})
        rows = result.fetchall()

    return rows


def main():
    print("=== Boksökning ===")
    while True:
        book_search = input("\nSök boktitel (eller 'avsluta'): ").strip()
        if book_search.lower() == "avsluta":
            break
        if not book_search:
            continue

        books = search_books(book_search)

        if not books:
            print("Inga böcker hittades.")
            continue

        print(f"\n{'Titel':<40} {'Författare':<25} {'Butik':<20} {'Antal'}")
        print("-" * 94)
        for row in books:
            print(f"{row.titel:<40} {row.forfattare:<25} {row.butik:<20} {row.antal_exemplar}")


if __name__ == "__main__":
    main()