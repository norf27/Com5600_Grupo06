import pyodbc
import pandas as pd

def obtener_conexion():
    conn_str = r"DRIVER={ODBC Driver 17 for SQL Server};SERVER=DESKTOP-0O40VV6\SQLEXPRESS;DATABASE=sist_gestion_parques;Trusted_Connection=yes;"
    return pyodbc.connect(conn_str)

def consultar_datos(query, params=()):
    conn = obtener_conexion()
    df = pd.read_sql(query, conn, params=params)
    conn.close()
    return df

def ejecutar_accion(query, params=()):
    conn = obtener_conexion()
    cursor = conn.cursor()
    cursor.execute(query, params)
    conn.commit()
    conn.close()