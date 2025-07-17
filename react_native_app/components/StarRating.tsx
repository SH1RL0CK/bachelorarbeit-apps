import React from "react";
import { StyleSheet, View } from "react-native";
import { IconButton, useTheme } from "react-native-paper";

interface StarRatingProps {
    rating: number;
    onRatingChanged?: (rating: number) => void;
    maxRating?: number;
    starSize?: number;
    isEditable?: boolean;
}

export const StarRating: React.FC<StarRatingProps> = ({
    rating,
    onRatingChanged,
    maxRating = 5,
    starSize = 24,
    isEditable = true,
}) => {
    const theme = useTheme();

    const activeColor = "#FFC107"; // Amber color like Flutter
    const inactiveColor = theme.colors.outline;

    return (
        <View
            style={styles.container}
            accessible={true}
            accessibilityRole="adjustable"
            accessibilityLabel={`Bewertung: ${rating} von ${maxRating} Sternen`}
            accessibilityValue={{
                min: 0,
                max: maxRating,
                now: rating,
                text: `${rating}/${maxRating}`,
            }}
            accessibilityHint={
                isEditable ? "Tippen um Bewertung zu ändern" : undefined
            }
        >
            {Array.from({ length: maxRating }, (_, index) => {
                const starNumber = index + 1;
                const isActive = index < rating;

                return (
                    <IconButton
                        key={index}
                        icon={index < rating ? "star" : "star-outline"}
                        iconColor={index < rating ? activeColor : inactiveColor}
                        size={starSize}
                        onPress={
                            isEditable && onRatingChanged
                                ? () => onRatingChanged(index + 1)
                                : undefined
                        }
                        style={[styles.star, !isEditable && styles.nonEditable]}
                        accessible={isEditable}
                        accessibilityRole={isEditable ? "button" : undefined}
                        accessibilityLabel={`Stern ${starNumber}`}
                        accessibilityValue={{
                            text: isActive ? "ausgefüllt" : "nicht ausgefüllt",
                        }}
                        accessibilityHint={
                            isEditable
                                ? `Tippen für ${starNumber} Sterne`
                                : undefined
                        }
                    />
                );
            })}
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flexDirection: "row",
        alignItems: "center",
    },
    star: {
        margin: 0,
        marginHorizontal: 2,
    },
    nonEditable: {
        // Reduce touch target for non-editable stars
        padding: 0,
    },
});
