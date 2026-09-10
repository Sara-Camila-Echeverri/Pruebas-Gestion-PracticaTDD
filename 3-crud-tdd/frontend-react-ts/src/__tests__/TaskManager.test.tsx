import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import React from 'react';
import { TaskManager } from '../components/TaskManager';

describe('TaskManager Frontend CRUD with TDD (React + TypeScript)', () => {
  it('READ: renders empty state when there are no tasks', () => {
    render(<TaskManager initialTasks={[]} />);
    expect(screen.getByText(/no hay tareas registradas/i)).toBeInTheDocument();
  });

  it('READ: renders initial tasks correctly', () => {
    const initial = [
      { id: '1', title: 'Aprender TDD', completed: false },
      { id: '2', title: 'Construir CRUD en React', completed: true },
    ];
    render(<TaskManager initialTasks={initial} />);

    expect(screen.getByText('Aprender TDD')).toBeInTheDocument();
    expect(screen.getByText('Construir CRUD en React')).toBeInTheDocument();
    expect(screen.getByText(/total: 2/i)).toBeInTheDocument();
  });

  it('CREATE: allows adding a new task', () => {
    render(<TaskManager initialTasks={[]} />);

    const input = screen.getByPlaceholderText(/escribe una nueva tarea/i);
    const addButton = screen.getByRole('button', { name: /agregar/i });

    fireEvent.change(input, { target: { value: 'Nueva Tarea TDD' } });
    fireEvent.click(addButton);

    expect(screen.getByText('Nueva Tarea TDD')).toBeInTheDocument();
    expect(screen.getByText(/total: 1/i)).toBeInTheDocument();
    expect(input).toHaveValue('');
  });

  it('CREATE (validation): prevents adding empty tasks', () => {
    render(<TaskManager initialTasks={[]} />);

    const addButton = screen.getByRole('button', { name: /agregar/i });
    fireEvent.click(addButton);

    expect(screen.getByText(/no hay tareas registradas/i)).toBeInTheDocument();
  });

  it('UPDATE: toggles completion state of a task', () => {
    const initial = [{ id: '1', title: 'Tarea Pendiente', completed: false }];
    render(<TaskManager initialTasks={initial} />);

    const checkbox = screen.getByRole('checkbox');
    expect(checkbox).not.toBeChecked();

    fireEvent.click(checkbox);
    expect(checkbox).toBeChecked();
  });

  it('UPDATE: edits an existing task title', () => {
    const initial = [{ id: '1', title: 'Título Original', completed: false }];
    render(<TaskManager initialTasks={initial} />);

    const editButton = screen.getByRole('button', { name: /editar/i });
    fireEvent.click(editButton);

    const editInput = screen.getByDisplayValue('Título Original');
    fireEvent.change(editInput, { target: { value: 'Título Modificado' } });

    const saveButton = screen.getByRole('button', { name: /guardar/i });
    fireEvent.click(saveButton);

    expect(screen.getByText('Título Modificado')).toBeInTheDocument();
    expect(screen.queryByText('Título Original')).not.toBeInTheDocument();
  });

  it('DELETE: removes a task from the list', () => {
    const initial = [{ id: '1', title: 'Tarea para eliminar', completed: false }];
    render(<TaskManager initialTasks={initial} />);

    expect(screen.getByText('Tarea para eliminar')).toBeInTheDocument();

    const deleteButton = screen.getByRole('button', { name: /eliminar/i });
    fireEvent.click(deleteButton);

    expect(screen.queryByText('Tarea para eliminar')).not.toBeInTheDocument();
    expect(screen.getByText(/no hay tareas registradas/i)).toBeInTheDocument();
  });
});
