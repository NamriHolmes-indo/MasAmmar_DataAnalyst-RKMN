import psycopg2

try:
    connection = psycopg2.connect(
        host="10.0.0.94",
        database="homelab",
        user="naufal_tampan_rakamin_test_u",
        password="m@Sn4UFalt@mPan",
        port="5433",
    )

    print("Koneksi ke database berhasil!")

except Exception as e:
    print("Terjadi kesalahan saat koneksi:", e)
finally:
    if connection:
        connection.close()
        print("Koneksi ditutup.")
