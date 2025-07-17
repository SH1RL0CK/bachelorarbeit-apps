package org.example.project.widgets

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Movie
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.semantics.*
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import org.example.project.models.Quote

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuoteCard(
    quote: Quote,
    onTap: (() -> Unit)? = null,
) {
    val semanticLabel = buildString {
        append("Zitat: ${quote.text}. ")
        if (!quote.character.isNullOrEmpty()) {
            append("Charakter: ${quote.character}. ")
        } else {
            append("Charakter: Unbekannt. ")
        }
        append("Film: ${quote.movie}")
        if (quote.year != null) {
            append(". Jahr: ${quote.year}")
        }
        append(". Bewertung: ${quote.rating} von 5 Sternen.")
    }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
            .clip(RoundedCornerShape(12.dp))
            .semantics(mergeDescendants = true) {
                contentDescription = semanticLabel
                if (onTap != null) {
                    role = Role.Button
                    onClick("Tippen, um Details zu sehen") {
                        onTap()
                        true
                    }
                }
            }
            .clickable { onTap?.invoke() },
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .clearAndSetSemantics { },
        ) {
            Text(
                text = "\"${quote.text}\"",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.87f)
            )

            Spacer(modifier = Modifier.height(12.dp))

            if (!quote.character.isNullOrEmpty()) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Person,
                        contentDescription = null,
                        modifier = Modifier.size(16.dp),
                        tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.54f)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = quote.character,
                        fontSize = 14.sp,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.87f),
                        fontWeight = FontWeight.Medium
                    )
                }
                Spacer(modifier = Modifier.height(8.dp))
            }

            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Movie,
                    contentDescription = null,
                    modifier = Modifier.size(16.dp),
                    tint = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.54f)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = if (quote.year != null) "${quote.movie} (${quote.year})" else quote.movie,
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.87f),
                    fontWeight = FontWeight.Medium,
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.height(12.dp))

            StarRating(
                rating = quote.rating,
                starSize = 16.dp,
                isEditable = false
            )
        }
    }
}
