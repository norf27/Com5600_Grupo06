import streamlit as st
import db
import os
import pyodbc
from datetime import datetime

st.set_page_config(page_title="Gestion de Parques", layout="wide")

st.markdown("""
    <style>
    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    header {visibility: hidden;}
    </style>
    """, unsafe_allow_html=True)

st.sidebar.title("Menu Principal")
opcion = st.sidebar.radio("Ir a:", ["ABM Centralizado", "Importar Nacional", "Generar XML"])

# --- SECCION 1: ABM CENTRALIZADO ---
if opcion == "ABM Centralizado":
    st.header("Centro de Control ABM")
    
    tab_parques, tab_tipos, tab_provincias = st.tabs(["Parques Nacionales", "Tipos de Parque", "Provincias"])
    
    # -------------------------------------------------------------------------
    # PESTAÑA 1: ABM PARQUES
    # -------------------------------------------------------------------------
    with tab_parques:
        st.subheader("Administración de Parques Nacionales")
        try:
            query_parques = """
                SELECT P.ID, P.Nombre, P.Superficie, T.Nombre AS Tipo, PROV.Nombre AS Provincia, 
                       P.Anio_Creacion, P.Ambiente_Ecoregion
                FROM Parque.Parque P
                LEFT JOIN Parque.Tipo_parque T ON P.ID_tipo = T.ID
                LEFT JOIN Parque.Provincia PROV ON P.ID_provincia = PROV.ID
                WHERE P.Estado = 'A'
            """
            df_parques = db.consultar_datos(query_parques)
            df_provincias = db.consultar_datos("SELECT ID, Nombre FROM Parque.Provincia WHERE Estado = 'A'")
            df_tipos = db.consultar_datos("SELECT ID, Nombre FROM Parque.Tipo_parque WHERE Estado = 'A'")
            
            if not df_parques.empty:
                st.dataframe(df_parques, hide_index=True, use_container_width=True)
            else:
                st.info("No hay parques activos registrados.")
        except Exception as e:
            st.error(f"Error al consultar Parques: {e}")

        st.write("---")
        dict_prov = {row['Nombre']: row['ID'] for _, row in df_provincias.iterrows()} if 'df_provincias' in locals() else {}
        dict_tipo = {row['Nombre']: row['ID'] for _, row in df_tipos.iterrows()} if 'df_tipos' in locals() else {}

        col1, col2, col3 = st.columns(3)
        
        with col1:
            st.markdown("### Alta de Parque")
            p_nombre = st.text_input("Nombre del Parque:", max_chars=100, key="p_add_n").strip()
            p_superficie = st.number_input("Superficie (HA):", min_value=0.0, step=0.1, key="p_add_s")
            p_anio = st.number_input("Año de Creación:", min_value=1800, max_value=datetime.now().year, value=2026, key="p_add_a")
            p_ambiente = st.text_input("Ambiente / Ecorregión:", max_chars=250, key="p_add_am").strip()
            
            if dict_prov and dict_tipo:
                p_prov_name = st.selectbox("Provincia asignada:", list(dict_prov.keys()), key="p_add_pv")
                p_tipo_name = st.selectbox("Tipo de Parque:", list(dict_tipo.keys()), key="p_add_tp")

                if st.button("Agregar Parque", use_container_width=True):
                    if p_nombre == "":
                        st.error("El nombre es obligatorio.")
                    else:
                        try:
                            fecha_actual = datetime.now()
                            db.ejecutar_accion(
                                "EXEC Parque.SP_Parque_Alta @Nombre=?, @Superficie=?, @ID_tipo=?, @ID_provincia=?, @Anio_Creacion=?, @Ambiente_Ecoregion=?, @Fecha_Ultima_Actualizacion=?",
                                (p_nombre, p_superficie, dict_tipo[p_tipo_name], dict_prov[p_prov_name], p_anio, p_ambiente, fecha_actual)
                            )
                            st.success(f"¡Parque '{p_nombre}' agregado!")
                            st.rerun()
                        except pyodbc.Error as sql_err:
                            st.error(f"Error de BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.warning("Cargar al menos una Provincia y un Tipo de Parque activos primero.")

        with col2:
            st.markdown("### Modificar Parque")
            if not df_parques.empty:
                dict_edit_parque = {f"{row['Nombre']} (ID: {row['ID']})": row['ID'] for _, row in df_parques.iterrows()}
                parque_sel = st.selectbox("Parque a editar:", list(dict_edit_parque.keys()), key="p_mod_sel")
                id_a_modificar = dict_edit_parque[parque_sel]
                current_row = df_parques[df_parques['ID'] == id_a_modificar].iloc[0]
                
                m_nombre = st.text_input("Nuevo Nombre:", value=current_row['Nombre'], max_chars=100, key="p_mod_n").strip()
                m_superficie = st.number_input("Nueva Superficie:", value=float(current_row['Superficie']), min_value=0.0, key="p_mod_s")
                m_anio = st.number_input("Nuevo Año:", value=int(current_row['Anio_Creacion']), min_value=1800, key="p_mod_a")
                m_ambiente = st.text_input("Nuevo Ambiente:", value=str(current_row['Ambiente_Ecoregion']), max_chars=250, key="p_mod_am").strip()
                m_prov_name = st.selectbox("Cambiar Provincia:", list(dict_prov.keys()), index=list(dict_prov.keys()).index(current_row['Provincia']) if current_row['Provincia'] in dict_prov else 0, key="p_mod_pv")
                m_tipo_name = st.selectbox("Cambiar Tipo:", list(dict_tipo.keys()), index=list(dict_tipo.keys()).index(current_row['Tipo']) if current_row['Tipo'] in dict_tipo else 0, key="p_mod_tp")

                if st.button("Guardar Cambios Parque", use_container_width=True):
                    if m_nombre == "":
                        st.error("El nombre del parque no puede quedar vacío.")
                    else:
                        try:
                            fecha_actual = datetime.now()
                            db.ejecutar_accion(
                                "EXEC Parque.SP_Parque_Modificar @ID=?, @Nombre=?, @Superficie=?, @ID_tipo=?, @ID_provincia=?, @Anio_Creacion=?, @Ambiente_Ecoregion=?, @Fecha_Ultima_Actualizacion=?",
                                (id_a_modificar, m_nombre, m_superficie, dict_tipo[m_tipo_name], dict_prov[m_prov_name], m_anio, m_ambiente, fecha_actual)
                            )
                            st.success("¡Parque modificado correctamente!")
                            st.rerun()
                        except pyodbc.Error as sql_err:
                            st.error(f"Error de BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay parques activos.")

        with col3:
            st.markdown("### Baja Lógica Parque")
            if not df_parques.empty:
                id_baja = st.number_input("ID del Parque a desactivar:", min_value=1, step=1, key="p_del_id")
                if st.button("Eliminar Parque", use_container_width=True):
                    try:
                        db.ejecutar_accion("EXEC Parque.SP_Parque_Baja @ID=?", (id_baja,))
                        st.success(f"¡Parque ID {id_baja} dado de baja!")
                        st.rerun()
                    except pyodbc.Error as sql_err:
                        st.error(f"Error: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay parques activos.")

    # -------------------------------------------------------------------------
    # PESTAÑA 2: ABM TIPO PARQUE
    # -------------------------------------------------------------------------
    with tab_tipos:
        st.subheader("Administración de Tipos de Parque")
        try:
            df_t = db.consultar_datos("SELECT ID, Nombre, Descripcion FROM Parque.Tipo_parque WHERE Estado = 'A'")
            if not df_t.empty:
                st.dataframe(df_t, hide_index=True, use_container_width=True)
            else:
                st.info("No hay Tipos de Parque activos.")
        except Exception as e:
            st.error(f"Error: {e}")

        st.write("---")
        t_col1, t_col2, t_col3 = st.columns(3)

        with t_col1:
            st.markdown("### Alta Tipo")
            t_nombre = st.text_input("Nombre del Tipo:", max_chars=100, key="t_add_n").strip()
            t_desc = st.text_input("Descripción:", max_chars=250, key="t_add_d").strip()
            if st.button("Agregar Tipo", use_container_width=True):
                if t_nombre == "" or t_desc == "":
                    st.error("Todos los campos son obligatorios.")
                else:
                    try:
                        db.ejecutar_accion("EXEC Parque.SP_TipoParque_Alta @Nombre=?, @Descripcion=?", (t_nombre, t_desc))
                        st.success("¡Tipo de parque guardado!")
                        st.rerun()
                    except pyodbc.Error as sql_err:
                        st.error(f"Error: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")

        with t_col2:
            st.markdown("### Modificar Tipo")
            if not df_t.empty:
                dict_edit_t = {f"{row['Nombre']} (ID: {row['ID']})": row['ID'] for _, row in df_t.iterrows()}
                t_sel = st.selectbox("Tipo a editar:", list(dict_edit_t.keys()), key="t_mod_sel")
                id_t_mod = dict_edit_t[t_sel]
                curr_t = df_t[df_t['ID'] == id_t_mod].iloc[0]

                mt_nombre = st.text_input("Nuevo Nombre:", value=curr_t['Nombre'], key="t_mod_n").strip()
                mt_desc = st.text_input("Nueva Descripción:", value=curr_t['Descripcion'], key="t_mod_d").strip()

                if st.button("Guardar Cambios Tipo", use_container_width=True):
                    if mt_nombre == "" or mt_desc == "":
                        st.error("El nombre y la descripción no pueden quedar vacíos.")
                    else:
                        try:
                            db.ejecutar_accion("EXEC Parque.SP_TipoParque_Modificar @ID=?, @Nombre=?, @Desc=?", (id_t_mod, mt_nombre, mt_desc))
                            st.success("¡Tipo modificado!")
                            st.rerun()
                        except pyodbc.Error as sql_err:
                            st.error(f"Error de validación: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay registros para modificar.")

        with t_col3:
            st.markdown("### Baja Lógica Tipo")
            if not df_t.empty:
                id_t_del = st.number_input("ID del Tipo a desactivar:", min_value=1, step=1, key="t_del_id")
                if st.button("Eliminar Tipo", use_container_width=True):
                    try:
                        db.ejecutar_accion("EXEC Parque.SP_TipoParque_Baja @ID=?", (id_t_del,))
                        st.success("¡Registro dado de baja!")
                        st.rerun()
                    except pyodbc.Error as sql_err:
                        st.error(f"Error de BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay registros para dar de baja.")

    # -------------------------------------------------------------------------
    # PESTAÑA 3: ABM PROVINCIAS
    # -------------------------------------------------------------------------
    with tab_provincias:
        st.subheader("Administración de Provincias")
        try:
            df_p = db.consultar_datos("SELECT ID, Nombre FROM Parque.Provincia WHERE Estado = 'A'")
            if not df_p.empty:
                st.dataframe(df_p, hide_index=True, use_container_width=True)
            else:
                st.info("No hay provincias activas.")
        except Exception as e:
            st.error(f"Error: {e}")

        st.write("---")
        p_col1, p_col2, p_col3 = st.columns(3)

        with p_col1:
            st.markdown("### Alta Provincia")
            prov_nueva = st.text_input("Nombre de la Provincia:", max_chars=100, key="p_tab_add").strip()
            if st.button("Agregar Provincia", use_container_width=True):
                if prov_nueva == "":
                    st.error("El nombre no puede estar vacío.")
                else:
                    try:
                        db.ejecutar_accion("EXEC Parque.SP_Provincia_Alta @Nombre=?", (prov_nueva,))
                        st.success("¡Provincia registrada!")
                        st.rerun()
                    except pyodbc.Error as sql_err:
                        st.error(f"Error BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")

        with p_col2:
            st.markdown("### Modificar Provincia")
            if not df_p.empty:
                dict_edit_p = {f"{row['Nombre']} (ID: {row['ID']})": row['ID'] for _, row in df_p.iterrows()}
                p_sel = st.selectbox("Provincia a editar:", list(dict_edit_p.keys()), key="p_tab_sel")
                id_p_mod = dict_edit_p[p_sel]
                curr_p = df_p[df_p['ID'] == id_p_mod].iloc[0]

                mp_nombre = st.text_input("Nuevo Nombre:", value=curr_p['Nombre'], key="p_tab_mod_n").strip()
                if st.button("Guardar Cambios Prov", use_container_width=True):
                    if mp_nombre == "":
                        st.error("El nombre de la provincia no puede quedar vacío.")
                    else:
                        try:
                            db.ejecutar_accion("EXEC Parque.SP_Provincia_Modificar @ID=?, @Nombre=?", (id_p_mod, mp_nombre))
                            st.success("¡Provincia actualizada!")
                            st.rerun()
                        except pyodbc.Error as sql_err:
                            st.error(f"Error BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay provincias activas para modificar.")

        with p_col3:
            st.markdown("### Baja Lógica Provincia")
            if not df_p.empty:
                id_p_del = st.number_input("ID de la Provincia a desactivar:", min_value=1, step=1, key="p_tab_del_id")
                if st.button("Desactivar Provincia", use_container_width=True):
                    try:
                        db.ejecutar_accion("EXEC Parque.SP_Provincia_Baja @ID=?", (id_p_del,))
                        st.success(f"¡Provincia cambiada a Inactivo!")
                        st.rerun()
                    except pyodbc.Error as sql_err:
                        st.error(f"Error BD: {sql_err.args[1] if len(sql_err.args) > 1 else sql_err}")
            else:
                st.write("No hay provincias para dar de baja.")

# --- SECCIÓN 2: IMPORTACIÓN (ETL) ---
elif opcion == "Importar Nacional":
    st.header("Importar Datos del SIB")
    archivo = st.file_uploader("Seleccionar archivo CSV", type=["csv"])
    if archivo:
        if st.button("Iniciar Importación a SQL"):
            temp_dir = r"C:\Temp"
            os.makedirs(temp_dir, exist_ok=True)
            ruta = os.path.join(temp_dir, archivo.name)
            try:
                with open(ruta, "wb") as f:
                    f.write(archivo.getbuffer())
                db.ejecutar_accion("EXEC Staging.SP_Importar_Nacional @RutaArchivo=?", (ruta,))
                st.success("¡Proceso de importación finalizado con éxito!")
                df_log = db.consultar_datos("SELECT * FROM Staging.Log_Errores_Importacion")
                if not df_log.empty:
                    st.warning("Inconsistencias registradas en el Log:")
                    st.dataframe(df_log, hide_index=True)
                else:
                    st.info("No se registraron errores de consistencia en el log.")
            except Exception as e:
                st.error(f"Error crítico durante la importación: {e}")
            finally:
                if os.path.exists(ruta):
                    os.remove(ruta)

# --- SECCIÓN 3: REPORTE XML ---
elif opcion == "Generar XML":
    st.header("Reporte Financiero de Deudores (Formato XML)")
    st.write("Seleccioná una fecha límite para consultar las empresas concesionarias que registran deudas.")

    # 1. Componente interactivo para elegir la fecha del reporte
    fecha_seleccionada = st.date_input("Fecha límite de consulta:", datetime.now().date())

    if st.button("Generar Reporte XML"):
        try:
            # 2. Query optimizada invocando el SP de deudores con parámetro seguro
            # Colocamos un alias a la columna para asegurar la lectura del string XML
            query = """
                EXEC Concesiones.SP_MostrarDeudores @Fecha = ?;
            """
            
            conn = db.obtener_conexion()
            cursor = conn.cursor()
            
            # Ejecutamos pasando la fecha seleccionada en la interfaz web
            cursor.execute(query, (str(fecha_seleccionada),))
            row = cursor.fetchone()
            
            if row and row[0]:
                xml_datos = row[0]
                
                st.success("¡Reporte XML compilado de forma exitosa desde SQL Server!")
                
                # 3. Botón de descarga nativo para guardar el archivo localmente
                st.download_button(
                    label="Descargar Archivo XML", 
                    data=xml_datos, 
                    file_name=f"reporte_deudores_{fecha_seleccionada}.xml", 
                    mime="application/xml"
                )
                
            else:
                st.info("No se encontraron registros de deudores para la fecha seleccionada.")
                
            conn.close()
            
        except Exception as e:
            st.error(f"Error al generar el reporte XML: {e}")