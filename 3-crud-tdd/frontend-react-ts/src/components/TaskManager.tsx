import React, { useState } from 'react';
import { Task } from '../types';

interface TaskManagerProps {
  initialTasks?: Task[];
}

export const TaskManager: React.FC<TaskManagerProps> = ({ initialTasks = [] }) => {
  const [tasks, setTasks] = useState<Task[]>(initialTasks);
  const [newTitle, setNewTitle] = useState('');
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editTitle, setEditTitle] = useState('');

  // CREATE
  const handleAddTask = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = newTitle.trim();
    if (!trimmed) return;

    const newTask: Task = {
      id: Date.now().toString(),
      title: trimmed,
      completed: false,
    };
    setTasks((prev) => [...prev, newTask]);
    setNewTitle('');
  };

  // UPDATE: Toggle completed
  const handleToggleCompleted = (id: string) => {
    setTasks((prev) =>
      prev.map((t) => (t.id === id ? { ...t, completed: !t.completed } : t))
    );
  };

  // UPDATE: Start editing
  const handleStartEdit = (task: Task) => {
    setEditingId(task.id);
    setEditTitle(task.title);
  };

  // UPDATE: Save edit
  const handleSaveEdit = (id: string) => {
    const trimmed = editTitle.trim();
    if (trimmed) {
      setTasks((prev) =>
        prev.map((t) => (t.id === id ? { ...t, title: trimmed } : t))
      );
    }
    setEditingId(null);
    setEditTitle('');
  };

  // DELETE
  const handleDeleteTask = (id: string) => {
    setTasks((prev) => prev.filter((t) => t.id !== id));
  };

  return (
    <div style={{ maxWidth: 600, margin: '2rem auto', fontFamily: 'system-ui, sans-serif' }}>
      <h1>Gestor de Tareas (CRUD TDD en React)</h1>
      <p>Total: {tasks.length}</p>

      {/* CREATE FORM */}
      <form onSubmit={handleAddTask} style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <input
          type="text"
          placeholder="Escribe una nueva tarea..."
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
          style={{ flex: 1, padding: '0.5rem', fontSize: '1rem' }}
        />
        <button type="submit" style={{ padding: '0.5rem 1rem', cursor: 'pointer' }}>
          Agregar
        </button>
      </form>

      {/* READ LIST */}
      {tasks.length === 0 ? (
        <p>No hay tareas registradas.</p>
      ) : (
        <ul style={{ listStyle: 'none', padding: 0 }}>
          {tasks.map((task) => (
            <li
              key={task.id}
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                padding: '0.75rem',
                borderBottom: '1px solid #ddd',
              }}
            >
              {editingId === task.id ? (
                <div style={{ display: 'flex', gap: '0.5rem', flex: 1 }}>
                  <input
                    type="text"
                    value={editTitle}
                    onChange={(e) => setEditTitle(e.target.value)}
                    style={{ flex: 1, padding: '0.25rem' }}
                  />
                  <button onClick={() => handleSaveEdit(task.id)}>Guardar</button>
                  <button onClick={() => setEditingId(null)}>Cancelar</button>
                </div>
              ) : (
                <>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                    <input
                      type="checkbox"
                      checked={task.completed}
                      onChange={() => handleToggleCompleted(task.id)}
                    />
                    <span
                      style={{
                        textDecoration: task.completed ? 'line-through' : 'none',
                        color: task.completed ? '#888' : '#000',
                      }}
                    >
                      {task.title}
                    </span>
                  </div>
                  <div style={{ display: 'flex', gap: '0.5rem' }}>
                    <button onClick={() => handleStartEdit(task)}>Editar</button>
                    <button onClick={() => handleDeleteTask(task.id)} style={{ color: 'red' }}>
                      Eliminar
                    </button>
                  </div>
                </>
              )}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};
