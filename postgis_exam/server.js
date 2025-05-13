const express = require('express');
const cors = require('cors');
const path = require('path');
const db = require('./config_db');

const app = express();
const PORT = process.env.PORT || 4000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Rutas API
// Obtener todas las zonas sanitarias
app.get('/api/zonas', async (req, res) => {
  try {
    const result = await db.query(
      "SELECT id_zona, nombre, autoridad_sanitaria, nivel_riesgo, ST_AsGeoJSON(geom) as geojson FROM zona_sanitaria"
    );
    const features = result.rows.map(row => ({
      type: 'Feature',
      geometry: JSON.parse(row.geojson),
      properties: { ...row, geojson: undefined }
    }));
    res.json({ type: 'FeatureCollection', features });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener zonas sanitarias' });
  }
});

// Obtener todos los centros de salud
app.get('/api/centros', async (req, res) => {
  try {
    const result = await db.query(
      "SELECT id_centro, id_zona, nombre, tipo, nivel_atencion, capacidad_camas, especialidades, es_publico, estado, ST_AsGeoJSON(geom) as geojson FROM centro_salud"
    );
    const features = result.rows.map(row => ({
      type: 'Feature',
      geometry: JSON.parse(row.geojson),
      properties: { ...row, geojson: undefined }
    }));
    res.json({ type: 'FeatureCollection', features });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener centros de salud' });
  }
});

// Obtener centros de salud filtrados por tipo
app.get('/api/centros/tipo/:tipo', async (req, res) => {
  try {
    const { tipo } = req.params;
    const result = await db.query(
      "SELECT id_centro, id_zona, nombre, tipo, nivel_atencion, capacidad_camas, especialidades, es_publico, estado, ST_AsGeoJSON(geom) as geojson FROM centro_salud WHERE tipo = $1",
      [tipo]
    );
    
    const features = result.rows.map(row => {
      const geojson = JSON.parse(row.geojson);
      delete row.geojson;
      
      return {
        type: 'Feature',
        geometry: geojson,
        properties: row
      };
    });
    
    res.json({
      type: 'FeatureCollection',
      features
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al filtrar centros de salud por tipo' });
  }
});

// Obtener zonas sanitarias por nivel de riesgo
app.get('/api/zonas/riesgo/:nivel', async (req, res) => {
  try {
    const { nivel } = req.params;
    const result = await db.query(
      "SELECT id_zona, nombre, autoridad_sanitaria, nivel_riesgo, ST_AsGeoJSON(geom) as geojson FROM zona_sanitaria WHERE nivel_riesgo = $1",
      [nivel]
    );
    
    const features = result.rows.map(row => {
      const geojson = JSON.parse(row.geojson);
      delete row.geojson;
      
      return {
        type: 'Feature',
        geometry: geojson,
        properties: row
      };
    });
    
    res.json({
      type: 'FeatureCollection',
      features
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al filtrar zonas sanitarias por nivel de riesgo' });
  }
});

// Obtener centros dentro de una zona específica
app.get('/api/centros/zona/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      "SELECT id_centro, id_zona, nombre, tipo, nivel_atencion, capacidad_camas, especialidades, es_publico, estado, ST_AsGeoJSON(geom) as geojson FROM centro_salud WHERE id_zona = $1",
      [id]
    );
    
    const features = result.rows.map(row => {
      const geojson = JSON.parse(row.geojson);
      delete row.geojson;
      
      return {
        type: 'Feature',
        geometry: geojson,
        properties: row
      };
    });
    
    res.json({
      type: 'FeatureCollection',
      features
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener centros por zona' });
  }
});

// Obtener tipos de centros de salud disponibles
app.get('/api/centros/tipos', async (req, res) => {
  try {
    const result = await db.query(
      "SELECT DISTINCT tipo FROM centro_salud ORDER BY tipo"
    );
    
    res.json(result.rows.map(row => row.tipo));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener tipos de centros' });
  }
});

// Obtener niveles de riesgo disponibles
app.get('/api/zonas/niveles-riesgo', async (req, res) => {
  try {
    const result = await db.query(
      "SELECT DISTINCT nivel_riesgo FROM zona_sanitaria ORDER BY nivel_riesgo"
    );
    
    res.json(result.rows.map(row => row.nivel_riesgo));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener niveles de riesgo' });
  }
});

// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});