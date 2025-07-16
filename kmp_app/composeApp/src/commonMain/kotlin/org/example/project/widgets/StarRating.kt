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
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Composable
fun StarRating(
    rating: Int,
    starSize: Dp = 16.dp,
    isEditable: Boolean = false,
    onRatingChanged: ((Int) -> Unit)? = null
) {
    Row {
        for (i in 1..5) {
            val isFilled = i <= rating
            Icon(
                imageVector = if (isFilled) Icons.Filled.Star else Icons.Outlined.Star,
                contentDescription = null,
                modifier = Modifier
                    .size(starSize)
                    .then(
                        if (isEditable) {
                            Modifier.clickable { onRatingChanged?.invoke(i) }
                        } else {
                            Modifier
                        }
                    ),
                tint = if (isFilled) Color(0xFFFFD700) else MaterialTheme.colorScheme.onSurface.copy(alpha = 0.38f)
            )
            if (i < 5) {
                Spacer(modifier = Modifier.width(2.dp))
            }
        }
    }
}
