import React from "react";
import { StyleSheet, View } from "react-native";
import { Card, IconButton, Text, useTheme } from "react-native-paper";
import { Quote } from "../models/quote";
import { StarRating } from "./StarRating";

interface QuoteCardProps {
    quote: Quote;
    onTap?: () => void;
}

export const QuoteCard: React.FC<QuoteCardProps> = ({ quote, onTap }) => {
    const theme = useTheme();

    // Create comprehensive accessibility label similar to Flutter version
    const accessibilityLabel = `Zitat: ${quote.text}. Charakter: ${
        quote.character || "Unbekannt"
    }. Film: ${quote.movie}${
        quote.year ? `. Jahr: ${quote.year}` : ""
    }. Bewertung: ${quote.rating} von 5 Sternen.`;

    return (
        <Card
            style={[styles.card, { backgroundColor: theme.colors.surface }]}
            onPress={onTap}
            accessible={true}
            accessibilityRole="button"
            accessibilityLabel={accessibilityLabel}
            accessibilityHint="Tippen, um Details zu sehen"
        >
            <Card.Content style={styles.content}>
                {/* Quote text with quotation marks */}
                <Text
                    variant="bodyLarge"
                    style={[
                        styles.quoteText,
                        { color: theme.colors.onSurfaceVariant },
                    ]}
                    importantForAccessibility="no"
                >
                    &ldquo;{quote.text}&rdquo;
                </Text>

                <View style={styles.spacer} />

                {/* Character info with person icon */}
                {quote.character && (
                    <View style={styles.infoRow} importantForAccessibility="no">
                        <IconButton
                            icon="account"
                            size={16}
                            iconColor={theme.colors.onSurfaceVariant}
                            style={styles.infoIcon}
                            accessible={false}
                        />
                        <Text
                            variant="bodyMedium"
                            style={[
                                styles.infoText,
                                { color: theme.colors.onSurfaceVariant },
                            ]}
                            importantForAccessibility="no"
                        >
                            {quote.character}
                        </Text>
                    </View>
                )}

                {/* Movie info with movie icon */}
                <View style={styles.infoRow} importantForAccessibility="no">
                    <IconButton
                        icon="movie"
                        size={16}
                        iconColor={theme.colors.onSurfaceVariant}
                        style={styles.infoIcon}
                        accessible={false}
                    />
                    <Text
                        variant="bodyMedium"
                        style={[
                            styles.infoText,
                            { color: theme.colors.onSurfaceVariant },
                        ]}
                        importantForAccessibility="no"
                    >
                        {quote.year
                            ? `${quote.movie} (${quote.year})`
                            : quote.movie}
                    </Text>
                </View>

                {/* Rating display */}
                <View
                    style={styles.ratingContainer}
                    importantForAccessibility="no"
                >
                    <StarRating
                        rating={quote.rating}
                        starSize={16}
                        isEditable={false}
                    />
                </View>
            </Card.Content>
        </Card>
    );
};

const styles = StyleSheet.create({
    card: {
        marginHorizontal: 16,
        marginVertical: 8,
        elevation: 2,
    },
    content: {
        padding: 16,
    },
    quoteText: {
        fontSize: 16,
        fontWeight: "bold",
        fontStyle: "italic",
        lineHeight: 24,
    },
    spacer: {
        height: 5,
    },
    infoRow: {
        flexDirection: "row",
        alignItems: "center",
        marginBottom: 8,
    },
    infoIcon: {
        margin: 0,
        marginRight: 8,
    },
    infoText: {
        fontSize: 14,
        fontWeight: "500",
        flex: 1,
    },
    ratingContainer: {
        marginTop: 12,
    },
});
