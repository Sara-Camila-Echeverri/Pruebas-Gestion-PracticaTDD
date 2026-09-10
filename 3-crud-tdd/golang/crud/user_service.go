package crud

import (
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"
)

var (
	ErrUserNotFound   = errors.New("user not found")
	ErrInvalidInput   = errors.New("invalid input")
	ErrDuplicateEmail = errors.New("email already in use")
)

type User struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Role      string    `json:"role"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type UserService struct {
	mu     sync.RWMutex
	users  map[string]*User
	seq    int
}

func NewUserService() *UserService {
	return &UserService{
		users: make(map[string]*User),
	}
}

func (s *UserService) Create(name, email, role string) (*User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	trimmedName := strings.TrimSpace(name)
	trimmedEmail := strings.TrimSpace(email)
	trimmedRole := strings.TrimSpace(role)

	if trimmedName == "" || trimmedEmail == "" {
		return nil, ErrInvalidInput
	}

	for _, u := range s.users {
		if strings.EqualFold(u.Email, trimmedEmail) {
			return nil, ErrDuplicateEmail
		}
	}

	s.seq++
	now := time.Now()
	user := &User{
		ID:        fmt.Sprintf("usr-%04d", s.seq),
		Name:      trimmedName,
		Email:     trimmedEmail,
		Role:      trimmedRole,
		CreatedAt: now,
		UpdatedAt: now,
	}

	s.users[user.ID] = user
	return user, nil
}

func (s *UserService) GetByID(id string) (*User, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	user, exists := s.users[id]
	if !exists {
		return nil, ErrUserNotFound
	}
	return user, nil
}

func (s *UserService) GetAll() []*User {
	s.mu.RLock()
	defer s.mu.RUnlock()

	list := make([]*User, 0, len(s.users))
	for _, u := range s.users {
		list = append(list, u)
	}
	return list
}

func (s *UserService) Update(id, name, role string) (*User, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	user, exists := s.users[id]
	if !exists {
		return nil, ErrUserNotFound
	}

	trimmedName := strings.TrimSpace(name)
	trimmedRole := strings.TrimSpace(role)

	if trimmedName == "" {
		return nil, ErrInvalidInput
	}

	user.Name = trimmedName
	if trimmedRole != "" {
		user.Role = trimmedRole
	}
	user.UpdatedAt = time.Now()

	return user, nil
}

func (s *UserService) Delete(id string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if _, exists := s.users[id]; !exists {
		return ErrUserNotFound
	}

	delete(s.users, id)
	return nil
}
