package org.example.project.widgets

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.outlined.Star
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.*
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Composable
fun StarRating(
    rating: Int,
    starSize: Dp = 16.dp,
    isEditable: Boolean = false,
    onRatingChanged: ((Int) -> Unit)? = null,
    maxRating: Int = 5,
    activeColor: Color = Color(0xFFFFD700),
    inactiveColor: Color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
) {
    Row(
        modifier = Modifier.semantics(mergeDescendants = true) {
            contentDescription = "Bewertung: $rating von $maxRating Sternen"
            stateDescription = "$rating/$maxRating"
            if (isEditable) {
                onClick("Tippen um Bewertung zu ändern") { true }
            }
        }
    ) {
        for (i in 1..maxRating) {
            val isFilled = i <= rating
            Icon(
                imageVector = if (isFilled) Icons.Filled.Star else Icons.Outlined.Star,
                contentDescription = null,
                modifier = Modifier
                    .size(starSize)
                    .semantics {
                        contentDescription = "Stern $i"
                        stateDescription = if (isFilled) "ausgefüllt" else "nicht ausgefüllt"
                        if (isEditable && onRatingChanged != null) {
                            role = Role.Button
                            onClick("Stern $i auswählen") {
                                onRatingChanged(i)
                                true
                            }
                        }
                    }
                    .then(
                        if (isEditable && onRatingChanged != null) {
                            Modifier.clickable { onRatingChanged(i) }
                        } else {
                            Modifier
                        }
                    )
                    .padding(horizontal = 4.dp),
                tint = if (isFilled) activeColor else inactiveColor
            )
        }
    }
}
