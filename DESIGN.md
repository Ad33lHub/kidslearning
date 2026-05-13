---
name: Cosmic Discovery
colors:
  surface: '#131315'
  surface-dim: '#131315'
  surface-bright: '#39393b'
  surface-container-lowest: '#0e0e10'
  surface-container-low: '#1c1b1d'
  surface-container: '#201f21'
  surface-container-high: '#2a2a2c'
  surface-container-highest: '#353436'
  on-surface: '#e5e1e4'
  on-surface-variant: '#c7c5ce'
  inverse-surface: '#e5e1e4'
  inverse-on-surface: '#313032'
  outline: '#919097'
  outline-variant: '#46464d'
  surface-tint: '#c1c5e3'
  primary: '#c1c5e3'
  on-primary: '#2a2f47'
  primary-container: '#0b1026'
  on-primary-container: '#777c97'
  inverse-primary: '#585d77'
  secondary: '#ebb2ff'
  on-secondary: '#520072'
  secondary-container: '#b600f8'
  on-secondary-container: '#fff6fc'
  tertiary: '#c9ce00'
  on-tertiary: '#313300'
  tertiary-container: '#121300'
  on-tertiary-container: '#7f8200'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dde1ff'
  primary-fixed-dim: '#c1c5e3'
  on-primary-fixed: '#151a31'
  on-primary-fixed-variant: '#41455e'
  secondary-fixed: '#f8d8ff'
  secondary-fixed-dim: '#ebb2ff'
  on-secondary-fixed: '#320047'
  on-secondary-fixed-variant: '#74009f'
  tertiary-fixed: '#e6eb00'
  tertiary-fixed-dim: '#c9ce00'
  on-tertiary-fixed: '#1c1d00'
  on-tertiary-fixed-variant: '#484a00'
  background: '#131315'
  on-background: '#e5e1e4'
  surface-variant: '#353436'
typography:
  display-lg:
    fontFamily: Quicksand
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Quicksand
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Quicksand
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
  body-lg:
    fontFamily: Quicksand
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 28px
  body-md:
    fontFamily: Quicksand
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  label-lg:
    fontFamily: Nunito Sans
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-md:
    fontFamily: Nunito Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
  margin-tablet: 40px
---

## Brand & Style

The brand identity centers on the wonder of "Cosmic Exploration," designed to transform education into a magical journey through the stars. The personality is curious, encouraging, and high-energy, specifically tailored to captivate a younger audience while maintaining a premium, high-quality feel that parents trust.

This design system utilizes a blend of **Glassmorphism** and **Tactile** design styles. Surfaces feel like semi-transparent cockpit displays or floating holographic fragments, while interactive elements possess a subtle physical "squish" to provide satisfying feedback. Visuals are characterized by soft luminous glows, depth-heavy layering, and playful motion that mimics the low-gravity environment of space.

## Colors

The palette is rooted in a "Deep Space" dark mode. The primary background uses a deep navy to provide a high-contrast canvas for vibrant cosmic accents.

*   **Primary (Deep Navy):** Used for main backgrounds and structural containers.
*   **Secondary (Neon Purple):** Used for primary actions, progress indicators, and magical highlights.
*   **Tertiary (Electric Yellow):** Reserved for rewards, achievements, and critical call-outs to simulate starlight.
*   **Soft Teal:** Used for secondary information, navigational cues, and success states.

Gradients are encouraged for large surfaces, specifically transitioning from the deep navy into a subtle purple or teal hue to create the illusion of distant nebulae.

## Typography

This design system prioritizes approachability and readability. **Quicksand** is the primary typeface for its rounded terminals and friendly character, making it perfect for young learners. For technical data or small utility labels, **Nunito Sans** provides a slightly more structured but still compatible aesthetic.

All headlines should use "Sentence case" to feel more conversational and less formal. For mobile screens, use `display-lg` sparingly for achievement screens, defaulting to `headline-lg` for standard view headers to ensure content density remains appropriate for children’s smaller devices.

## Layout & Spacing

The layout utilizes a **fluid grid** system designed for high-touch targets. A 4-column grid is used for mobile devices, expanding to 8 columns for tablets. 

Spacing follows a 4px base unit. To maintain a "floating" and "airy" cosmic feel, vertical margins between sections are generous (typically `xl` or `32px`). Content containers should never feel cramped; internal padding for cards and modals should default to `lg` (24px) to ensure touch targets for children are large and forgiving.

## Elevation & Depth

Depth is established through **Glassmorphism** and **Outer Glows** rather than traditional heavy shadows.

1.  **Base Layer:** The deep navy background.
2.  **Surface Layer:** Semi-transparent containers (60-80% opacity) with a background blur (12px - 20px). These surfaces use a thin, 1px translucent white border to define the edge.
3.  **Interactive Layer:** Buttons and active chips feature a subtle `0px 0px 15px` outer glow in their respective accent color (Purple or Teal) to make them appear as if they are emitting light.
4.  **Floating Layer:** Modals and tooltips sit at the highest elevation, using a slightly more opaque background and a more pronounced glow to separate them from the content beneath.

## Shapes

The shape language is defined by "Soft Orbit" geometry. Avoid all sharp corners. Standard components use a 0.5rem (8px) radius, while larger cards and educational modules use 1.5rem (24px) to create a friendly, safe environment. 

Buttons and input fields should utilize a high roundedness (1rem or greater) to appear "pill-like," encouraging interaction. Icons should follow a consistent 2px stroke weight with rounded caps and joins to match the typography.

## Components

### Buttons
Primary buttons are vibrant Neon Purple with white text. They feature a "pressed" state where the button scales down slightly (95%) and the outer glow intensifies, creating a tactile, squishy feel.

### Cards
Educational cards use the Glassmorphism style: a semi-transparent navy fill with a blurred background. Cards should include a playful icon in the top right corner that relates to the cosmic theme (e.g., a small star or planet).

### Progress Bars
Progress trackers are designed as "Fuel Gauges" or "Orbit Paths." The track is a dark navy, while the active fill is a gradient from Neon Purple to Soft Teal, glowing at the leading edge.

### Inputs
Search and text fields use a deep navy fill with a Soft Teal 2px border. When focused, the border color transitions to Electric Yellow and gains a subtle yellow glow.

### Interactive "Orbs"
A unique component for this design system: circular floating action buttons that house navigation or special tools. These should have a slight floating animation (y-axis oscillation) to feel magical and alive.