const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgis_exam',
  password: '0964',
  port: 5432,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};