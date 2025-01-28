# Nome del compilatore
CC = gcc

# Opzioni del compilatore
CFLAGS = -Wall -I/usr/include/postgresql

# Librerie necessarie per PostgreSQL
LIBS = -lpq

# Nome del file sorgente e dell'eseguibile
SRC = file.c
OBJ = $(SRC:.c=.o)
EXEC = file

# Regola di default per compilare l'eseguibile
all: $(EXEC)

# Regola per compilare il file oggetto
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

# Regola per collegare il file oggetto e creare l'eseguibile
$(EXEC): $(OBJ)
	$(CC) $(OBJ) $(LIBS) -o $@

# Regola per pulire i file generati dalla compilazione
clean:
	rm -f $(OBJ) $(EXEC)

# Regola per pulire i file oggetto
clean_obj:
	rm -f $(OBJ)

# Regola per pulire l'eseguibile
clean_exec:
	rm -f $(EXEC)

.PHONY: all clean clean_obj clean_exec
