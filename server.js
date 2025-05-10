const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Configuração da conexão com o banco de dados
const db = mysql.createConnection({
  host: '10.0.0.51',
  user: 'luis_remote',
  password: 'Luisga1.',
  database: 'IEMA'  
});

db.connect(err => {
  if (err) {
    console.error('Erro ao conectar no banco:', err);
    process.exit(1);
  }
  console.log('Conectado ao MySQL!');
});

// Helper para SELECT
function handleSelect(query, params, res) {
  db.query(query, params, (err, results) => {
    if (err) {
      console.error('Erro ao executar consulta:', err);
      return res.status(500).json({ error: 'Erro interno no servidor' });
    }
    res.json(results);
  });
}

// Rotas de listagem
app.get('/', (req, res) => res.send('Servidor funcionando!'));
app.get('/api/turmas', (req, res) => handleSelect('SELECT * FROM turma', [], res));
app.get('/api/horario', (req, res) => handleSelect('SELECT * FROM horario', [], res));
app.get('/api/sala', (req, res) => handleSelect('SELECT * FROM sala', [], res));
app.get('/api/professor', (req, res) => handleSelect('SELECT * FROM professor', [], res));
app.get('/api/disciplina', (req, res) => handleSelect('SELECT * FROM disciplina', [], res));
app.get('/api/visualizar', (req, res) => {
  const query = `
    SELECT 
      a.id_alocacao, t.nome AS turma, d.nome AS disciplina,
      p.nome AS professor, s.nome AS sala,
      h.inicio, h.fim, a.dia_semana
    FROM alocacao a
    JOIN turma t ON a.id_turma = t.id_turma
    JOIN disciplina d ON a.id_disciplina = d.id_disciplina
    LEFT JOIN professor p ON a.id_professor = p.id_professor
    LEFT JOIN sala s ON a.id_sala = s.id_sala
    JOIN horario h ON a.id_horario = h.id_horario
    ORDER BY t.nome, a.dia_semana, h.inicio;
  `;

  db.query(query, [], (err, results) => {
    if (err) {
      console.error('Erro ao buscar alocações:', err);
      return res.status(500).json({ error: 'Erro ao buscar dados' });
    }
    res.json(results);
  });
});

// Listar alocações detalhadas
app.get('/api/alocacao', (req, res) => {
  const query = `
    SELECT a.id_alocacao, a.id_turma, t.nome AS turma,
           a.id_disciplina, d.nome AS disciplina,
           a.id_professor, p.nome AS professor,
           a.id_sala, s.nome AS sala,
           a.id_horario, h.inicio AS inicio, h.fim AS fim,
           a.dia_semana
    FROM alocacao a
    JOIN turma t ON a.id_turma = t.id_turma
    JOIN disciplina d ON a.id_disciplina = d.id_disciplina
    LEFT JOIN professor p ON a.id_professor = p.id_professor
    LEFT JOIN sala s ON a.id_sala = s.id_sala
    JOIN horario h ON a.id_horario = h.id_horario
  `;
  handleSelect(query, [], res);
});

// Inserir ou atualizar alocação (upsert)
app.post('/api/alocacao', (req, res) => {
  const { id_turma, id_disciplina, id_horario, dia_semana, id_professor, id_sala } = req.body;
  // Verifica se já existe alocação para mesma turma+horario+dia
  const selectExist = `
    SELECT id_alocacao FROM alocacao
    WHERE id_turma = ?
      AND id_horario = ?
      AND dia_semana = ?
    LIMIT 1
  `;
  db.query(selectExist, [id_turma, id_horario, dia_semana], (err, existRows) => {
    if (err) {
      console.error('Erro ao buscar alocação existente:', err);
      return res.status(500).json({ error: 'Erro interno' });
    }
    const existingId = existRows.length ? existRows[0].id_alocacao : null;
    // Checa conflito de sala/professor com outras alocações (exceto a própria se atualizando)
    const conflictQuery = `
      SELECT 1 FROM alocacao
      WHERE dia_semana = ?
        AND id_horario = ?
        AND (id_alocacao <> ? OR ? IS NULL)
        AND (id_sala = ? OR id_professor = ?)
      LIMIT 1
    `;
    db.query(conflictQuery,
      [dia_semana, id_horario, existingId, existingId, id_sala, id_professor],
      (err2, conflictRows) => {
        if (err2) {
          console.error('Erro ao checar conflitos:', err2);
          return res.status(500).json({ error: 'Erro interno' });
        }
        if (conflictRows.length) {
          return res.status(400).json({ error: 'Conflito de sala ou professor neste horário' });
        }
        if (existingId) {
          // Atualiza registro existente
          const updateQuery = `
            UPDATE alocacao
            SET id_disciplina = ?, id_professor = ?, id_sala = ?
            WHERE id_alocacao = ?
          `;
          db.query(updateQuery, [id_disciplina, id_professor || null, id_sala || null, existingId], (err3) => {
            if (err3) {
              console.error('Erro ao atualizar alocação:', err3);
              return res.status(500).json({ error: 'Erro ao atualizar' });
            }
            res.json({ id_alocacao: existingId });
          });
        } else {
          // Insere novo registro
          const insertQuery = `
            INSERT INTO alocacao (id_turma, id_disciplina, id_professor, id_sala, id_horario, dia_semana)
            VALUES (?, ?, ?, ?, ?, ?)
          `;
          db.query(insertQuery, [id_turma, id_disciplina, id_professor || null, id_sala || null, id_horario, dia_semana], (err4, result) => {
            if (err4) {
              console.error('Erro ao inserir alocação:', err4);
              return res.status(500).json({ error: 'Erro ao inserir' });
            }
            res.status(201).json({ id_alocacao: result.insertId });
          });
        }
      }
    );
  });
});

// Subir o servidor
const PORT = 3030;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor rodando em http://0.0.0.0:${PORT}/`);
});

