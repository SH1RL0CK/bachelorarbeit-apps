import React, { useState } from "react";
import { ScrollView, StyleSheet } from "react-native";
import {
    Button,
    Dialog,
    Portal,
    Text,
    TextInput,
    useTheme,
} from "react-native-paper";
import { createQuote, Quote } from "../models/quote";
import { StarRating } from "./StarRating";

interface QuoteDialogProps {
    visible: boolean;
    onDismiss: () => void;
    onSave: (quote: Quote) => void;
}

export const QuoteDialog: React.FC<QuoteDialogProps> = ({
    visible,
    onDismiss,
    onSave,
}) => {
    const theme = useTheme();
    const [text, setText] = useState("");
    const [movie, setMovie] = useState("");
    const [character, setCharacter] = useState("");
    const [year, setYear] = useState("");
    const [rating, setRating] = useState(1);
    const [errors, setErrors] = useState<{ text?: string; movie?: string }>({});

    const validateForm = (): boolean => {
        const newErrors: { text?: string; movie?: string } = {};

        if (!text.trim()) {
            newErrors.text = "Bitte geben Sie den Zitat-Text ein";
        }

        if (!movie.trim()) {
            newErrors.movie = "Bitte geben Sie den Namen des Films ein";
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleSave = () => {
        if (validateForm()) {
            const quote = createQuote({
                text: text.trim(),
                movie: movie.trim(),
                character: character.trim() || undefined,
                year: year ? parseInt(year, 10) || undefined : undefined,
                rating,
            });

            onSave(quote);
            handleClose();
        }
    };

    const handleClose = () => {
        // Reset form
        setText("");
        setMovie("");
        setCharacter("");
        setYear("");
        setRating(1);
        setErrors({});
        onDismiss();
    };

    return (
        <Portal>
            <Dialog
                visible={visible}
                onDismiss={handleClose}
                style={{ backgroundColor: theme.colors.surface }}
            >
                <Dialog.Title style={{ color: theme.colors.onSurface }}>
                    Neues Zitat hinzufügen
                </Dialog.Title>

                <Dialog.ScrollArea style={styles.scrollArea}>
                    <ScrollView style={styles.content}>
                        <TextInput
                            label="Zitat Text*"
                            placeholder="Geben Sie den Zitat-Text ein"
                            value={text}
                            onChangeText={setText}
                            mode="outlined"
                            multiline
                            numberOfLines={3}
                            error={!!errors.text}
                            style={styles.input}
                        />
                        {errors.text && (
                            <Text
                                variant="bodySmall"
                                style={[
                                    styles.errorText,
                                    { color: theme.colors.error },
                                ]}
                            >
                                {errors.text}
                            </Text>
                        )}

                        <TextInput
                            label="Film/Serie*"
                            placeholder="Name des Films oder der Serie"
                            value={movie}
                            onChangeText={setMovie}
                            mode="outlined"
                            error={!!errors.movie}
                            style={styles.input}
                        />
                        {errors.movie && (
                            <Text
                                variant="bodySmall"
                                style={[
                                    styles.errorText,
                                    { color: theme.colors.error },
                                ]}
                            >
                                {errors.movie}
                            </Text>
                        )}

                        <TextInput
                            label="Charakter"
                            placeholder="Wer hat das Zitat gesagt?"
                            value={character}
                            onChangeText={setCharacter}
                            mode="outlined"
                            style={styles.input}
                        />

                        <TextInput
                            label="Erscheinungsjahr"
                            placeholder="z.B. 1999"
                            value={year}
                            onChangeText={setYear}
                            mode="outlined"
                            keyboardType="numeric"
                            style={styles.input}
                        />

                        <Text
                            variant="bodyLarge"
                            style={[
                                styles.ratingLabel,
                                { color: theme.colors.onSurface },
                            ]}
                        >
                            Bewertung:
                        </Text>

                        <StarRating
                            rating={rating}
                            onRatingChanged={setRating}
                            starSize={28}
                            isEditable={true}
                        />
                    </ScrollView>
                </Dialog.ScrollArea>

                <Dialog.Actions>
                    <Button onPress={handleClose}>Abbrechen</Button>
                    <Button
                        mode="contained"
                        onPress={handleSave}
                        style={{ backgroundColor: theme.colors.primary }}
                    >
                        Speichern
                    </Button>
                </Dialog.Actions>
            </Dialog>
        </Portal>
    );
};

const styles = StyleSheet.create({
    scrollArea: {
        maxHeight: 400,
    },
    content: {
        paddingHorizontal: 0,
    },
    input: {
        marginBottom: 16,
    },
    errorText: {
        marginTop: -12,
        marginBottom: 8,
        marginLeft: 12,
    },
    ratingLabel: {
        marginBottom: 12,
        fontWeight: "500",
    },
});
