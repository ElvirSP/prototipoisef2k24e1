﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Capa_Vista_Cuentas_Corrientes
{
    public partial class Nav_examen : Form
    {
        public Nav_examen()
        {
            InitializeComponent();
            string idUsuario = Interfac_V3.UsuarioSesion.GetIdUsuario();
            string[] alias = { "codigo_aula", "nombre_aula", "estado_aula" };
            navegador1.AsignarAlias(alias);
            navegador1.AsignarSalida(this);
            navegador1.AsignarColorFondo(Color.FromArgb(218, 247, 245));
            navegador1.AsignarColorFuente(Color.Black);
            navegador1.AsignarTabla("aulas");
            navegador1.ObtenerIdAplicacion("2000");
            navegador1.ObtenerIdUsuario(idUsuario);
            navegador1.AsignarAyuda("1");
            navegador1.AsignarNombreForm("Registro de las aulas");
        }

        private void navegador1_Load(object sender, EventArgs e)
        {

        }
    }
}
