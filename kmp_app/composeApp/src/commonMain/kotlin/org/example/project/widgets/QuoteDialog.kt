package org.example.project.widgets

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import org.example.project.models.Quote
import kotlin.uuid.ExperimentalUuidApi
import kotlin.uuid.Uuid

@OptIn(ExperimentalUuidApi::class)
@Composable
fun QuoteDialog(
    quote: Quote? = null,
    onSave: (Quote) -> Unit,
    onDismiss: () -> Unit
) {
    var text by remember { mutableStateOf(quote?.text ?: "") }
    var movie by remember { mutableStateOf(quote?.movie ?: "") }
    var character by remember { mutableStateOf(quote?.character ?: "") }
    var year by remember { mutableStateOf(quote?.year?.toString() ?: "") }
    var rating by remember { mutableStateOf(quote?.rating ?: 1) }

    var textError by remember { mutableStateOf<String?>(null) }
    var movieError by remember { mutableStateOf<String?>(null) }

    fun validateForm(): Boolean {
        textError = if (text.isBlank()) "Bitte geben Sie den Zitat-Text ein" else null
        movieError = if (movie.isBlank()) "Bitte geben Sie den Namen des Films ein" else null

        return textError == null && movieError == null
    }

    Dialog(onDismissRequest = onDismiss) {
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight(),
            shape = MaterialTheme.shapes.large,
            color = MaterialTheme.colorScheme.surface
        ) {
            Column(
                modifier = Modifier
                    .padding(24.dp)
                    .verticalScroll(rememberScrollState())
            ) {
                Text(
                    text = if (quote == null) "Neues Zitat hinzufügen" else "Zitat bearbeiten",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Medium,
                    color = MaterialTheme.colorScheme.onSurface
                )

                Spacer(modifier = Modifier.height(16.dp))

                OutlinedTextField(
                    value = text,
                    onValueChange = {
                        text = it
                        textError = null
                    },
                    label = { Text("Zitat Text*") },
                    placeholder = { Text("Geben Sie den Zitat-Text ein") },
                    isError = textError != null,
                    supportingText = textError?.let { { Text(it) } },
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(16.dp))

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
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(16.dp))

                OutlinedTextField(
                    value = character,
                    onValueChange = { character = it },
                    label = { Text("Charakter") },
                    placeholder = { Text("Wer hat das Zitat gesagt?") },
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(16.dp))

                OutlinedTextField(
                    value = year,
                    onValueChange = { year = it },
                    label = { Text("Erscheinungsjahr") },
                    placeholder = { Text("z.B. 1999") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(24.dp))

                Text(
                    text = "Bewertung:",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.87f)
                )

                Spacer(modifier = Modifier.height(12.dp))

                StarRating(
                    rating = rating,
                    starSize = 28.dp,
                    isEditable = true,
                    onRatingChanged = { rating = it }
                )

                Spacer(modifier = Modifier.height(24.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End
                ) {
                    TextButton(onClick = onDismiss) {
                        Text("Abbrechen")
                    }

                    Spacer(modifier = Modifier.width(8.dp))

                    Button(
                        onClick = {
                            if (validateForm()) {
                                val newQuote = Quote(
                                    id = quote?.id ?: Uuid.random().toString(),
                                    text = text,
                                    movie = movie,
                                    character = character.ifBlank { null },
                                    year = year.toIntOrNull(),
                                    rating = rating
                                )
                                onSave(newQuote)
                            }
                        }
                    ) {
                        Text("Speichern")
                    }
                }
            }
        }
    }
}
