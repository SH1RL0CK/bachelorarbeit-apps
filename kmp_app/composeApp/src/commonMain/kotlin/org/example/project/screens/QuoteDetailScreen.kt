package org.example.project.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Save
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch
import org.example.project.models.Quote
import org.example.project.services.QuotesService
import org.example.project.widgets.StarRating

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuoteDetailScreen(
    quote: Quote,
    quotesService: QuotesService,
    onBack: () -> Unit,
    onQuoteUpdated: () -> Unit
) {
    var text by remember { mutableStateOf(quote.text) }
    var movie by remember { mutableStateOf(quote.movie) }
    var character by remember { mutableStateOf(quote.character ?: "") }
    var year by remember { mutableStateOf(quote.year?.toString() ?: "") }
    var rating by remember { mutableStateOf(quote.rating) }

    var textError by remember { mutableStateOf<String?>(null) }
    var movieError by remember { mutableStateOf<String?>(null) }

    var showDeleteDialog by remember { mutableStateOf(false) }
    var isLoading by remember { mutableStateOf(false) }

    val scope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }
    val focusManager = LocalFocusManager.current

    fun validateForm(): Boolean {
        textError = if (text.isBlank()) "Bitte geben Sie den Zitat-Text ein" else null
        movieError = if (movie.isBlank()) "Bitte geben Sie den Namen des Films ein" else null

        return textError == null && movieError == null
    }

    fun saveChanges() {
        if (validateForm()) {
            scope.launch {
                try {
                    isLoading = true
                    val updatedQuote = quote.copy(
                        text = text,
                        movie = movie,
                        character = character.ifBlank { null },
                        year = year.toIntOrNull(),
                        rating = rating
                    )
                    quotesService.updateQuote(updatedQuote)
                    snackbarHostState.showSnackbar(
                        message = "Änderungen gespeichert",
                        duration = SnackbarDuration.Short
                    )
                    onQuoteUpdated()
                } catch (e: Exception) {
                    snackbarHostState.showSnackbar(
                        message = "Fehler beim Speichern: ${e.message}",
                        duration = SnackbarDuration.Long
                    )
                } finally {
                    isLoading = false
                }
            }
        }
    }

    fun deleteQuote() {
        scope.launch {
            try {
                isLoading = true
                quotesService.deleteQuote(quote.id!!)
                snackbarHostState.showSnackbar(
                    message = "Zitat gelöscht",
                    duration = SnackbarDuration.Short
                )
                onQuoteUpdated()
                onBack()
            } catch (e: Exception) {
                snackbarHostState.showSnackbar(
                    message = "Fehler beim Löschen: ${e.message}",
                    duration = SnackbarDuration.Long
                )
            } finally {
                isLoading = false
            }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Zitat Details") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Zurück")
                    }
                }
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(24.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            OutlinedTextField(
                value = text,
                onValueChange = {
                    text = it
                    textError = null
                },
                label = { Text("Zitat*") },
                placeholder = { Text("Geben Sie den Zitat-Text ein") },
                isError = textError != null,
                supportingText = textError?.let { { Text(it) } },
                modifier = Modifier.fillMaxWidth(),
                maxLines = 3,
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Down) }
                )
            )

            OutlinedTextField(
                value = character,
                onValueChange = { character = it },
                label = { Text("Charakter") },
                placeholder = { Text("Wer hat das Zitat gesagt?") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Down) }
                )
            )

            OutlinedTextField(
                value = movie,
                onValueChange = {
                    movie = it
                    movieError = null
                },
                label = { Text("Film/Serie*") },
                placeholder = { Text("Name des Films oder der Serie") },
                isError = movieError != null,
                supportingText = movieError?.let { { Text(it) } },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Down) }
                )
            )

            OutlinedTextField(
                value = year,
                onValueChange = { year = it },
                label = { Text("Jahr") },
                placeholder = { Text("z.B. 2004") },
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done
                ),
                keyboardActions = KeyboardActions(
                    onDone = { focusManager.clearFocus() }
                ),
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = "Zitat bewerten:",
                fontSize = 16.sp,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.87f)
            )

            StarRating(
                rating = rating,
                starSize = 32.dp,
                isEditable = true,
                onRatingChanged = { rating = it }
            )

            Spacer(modifier = Modifier.height(32.dp))

            Button(
                onClick = { saveChanges() },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading
            ) {
                if (isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(16.dp),
                        color = Color.White
                    )
                } else {
                    Icon(Icons.Default.Save, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Änderungen speichern")
                }
            }

            OutlinedButton(
                onClick = { showDeleteDialog = true },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading,
                colors = ButtonDefaults.outlinedButtonColors(
                    contentColor = MaterialTheme.colorScheme.error
                )
            ) {
                Icon(Icons.Default.Delete, contentDescription = null)
                Spacer(modifier = Modifier.width(8.dp))
                Text("Zitat löschen")
            }
        }
    }

    if (showDeleteDialog) {
        AlertDialog(
            onDismissRequest = { showDeleteDialog = false },
            title = { Text("Zitat löschen") },
            text = { Text("Möchten Sie dieses Zitat wirklich löschen?") },
            confirmButton = {
                Button(
                    onClick = {
                        showDeleteDialog = false
                        deleteQuote()
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = MaterialTheme.colorScheme.error
                    )
                ) {
                    Text("Löschen", color = Color.White)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteDialog = false }) {
                    Text("Abbrechen")
                }
            }
        )
    }
}
