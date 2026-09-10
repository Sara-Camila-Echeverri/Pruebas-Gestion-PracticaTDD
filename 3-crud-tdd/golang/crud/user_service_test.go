package crud

import (
	"errors"
	"testing"
)

func TestUserServiceTDD(t *testing.T) {
	t.Run("Create User", func(t *testing.T) {
		service := NewUserService()

		// Success
		user, err := service.Create("Alice", "alice@example.com", "Admin")
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if user.ID == "" {
			t.Errorf("expected non-empty ID")
		}
		if user.Name != "Alice" || user.Email != "alice@example.com" || user.Role != "Admin" {
			t.Errorf("user fields mismatch: %+v", user)
		}

		// Validation: empty name
		_, err = service.Create("", "bob@example.com", "User")
		if !errors.Is(err, ErrInvalidInput) {
			t.Errorf("expected ErrInvalidInput, got %v", err)
		}

		// Validation: empty email
		_, err = service.Create("Bob", "", "User")
		if !errors.Is(err, ErrInvalidInput) {
			t.Errorf("expected ErrInvalidInput, got %v", err)
		}

		// Validation: duplicate email
		_, err = service.Create("Alice Clone", "alice@example.com", "User")
		if !errors.Is(err, ErrDuplicateEmail) {
			t.Errorf("expected ErrDuplicateEmail, got %v", err)
		}
	})

	t.Run("Get User By ID", func(t *testing.T) {
		service := NewUserService()
		created, _ := service.Create("Charlie", "charlie@example.com", "Editor")

		// Found
		found, err := service.GetByID(created.ID)
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if found.ID != created.ID || found.Name != "Charlie" {
			t.Errorf("found user mismatch: %+v", found)
		}

		// Not Found
		_, err = service.GetByID("non-existent-id")
		if !errors.Is(err, ErrUserNotFound) {
			t.Errorf("expected ErrUserNotFound, got %v", err)
		}
	})

	t.Run("Get All Users", func(t *testing.T) {
		service := NewUserService()
		if len(service.GetAll()) != 0 {
			t.Errorf("expected 0 users, got %d", len(service.GetAll()))
		}

		service.Create("User 1", "u1@example.com", "User")
		service.Create("User 2", "u2@example.com", "User")

		users := service.GetAll()
		if len(users) != 2 {
			t.Errorf("expected 2 users, got %d", len(users))
		}
	})

	t.Run("Update User", func(t *testing.T) {
		service := NewUserService()
		created, _ := service.Create("Dave", "dave@example.com", "User")

		// Update Success
		updated, err := service.Update(created.ID, "David", "SuperAdmin")
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if updated.Name != "David" || updated.Role != "SuperAdmin" {
			t.Errorf("updated fields mismatch: %+v", updated)
		}

		// Update Not Found
		_, err = service.Update("fake-id", "No One", "None")
		if !errors.Is(err, ErrUserNotFound) {
			t.Errorf("expected ErrUserNotFound, got %v", err)
		}

		// Update Invalid Name
		_, err = service.Update(created.ID, "", "Role")
		if !errors.Is(err, ErrInvalidInput) {
			t.Errorf("expected ErrInvalidInput, got %v", err)
		}
	})

	t.Run("Delete User", func(t *testing.T) {
		service := NewUserService()
		created, _ := service.Create("Eve", "eve@example.com", "Guest")

		// Delete Success
		err := service.Delete(created.ID)
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}

		// Verify deletion
		_, err = service.GetByID(created.ID)
		if !errors.Is(err, ErrUserNotFound) {
			t.Errorf("expected ErrUserNotFound after deletion, got %v", err)
		}

		// Delete Not Found
		err = service.Delete("unknown-id")
		if !errors.Is(err, ErrUserNotFound) {
			t.Errorf("expected ErrUserNotFound for missing ID, got %v", err)
		}
	})
}
