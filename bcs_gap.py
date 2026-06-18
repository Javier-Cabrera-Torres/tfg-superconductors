%matplotlib inline
import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import quad
from IPython.display import display

# Parámetros (kB = 1, Delta(0) = 1)
kB = 1.0
Delta0 = 1.0
Tc = 2*Delta0/3.528  # relación BCS: 2*Delta(0)/(kB*Tc) ~ 3.528

# Ecuación del gap restada (integral de 0 a infinito)
def gap_equation(Delta, T):
    if T <= 0:  # en T=0 el integrando se anula, la raíz es Delta = Delta(0)
        return np.log(Delta0/max(Delta, 1e-300))
    def integrand(xi):
        E = np.sqrt(xi**2+Delta**2)
        return (1-np.tanh(E/(2*kB*T)))/E
    val, _ = quad(integrand, 0, np.inf, limit=200)  # converge. El _ es porque devuelve dos variables.
    return np.log(Delta0/Delta)-val

# Método de bisección
def biseccion(f, a, b, tol=1e-8, max_iter=100):
    fa = f(a)
    fb = f(b)
    if fa*fb > 0:
        return None  # sin cambio de signo, no hay raíz no trivial
    for _ in range(max_iter):
        c = (a+b)/2.0
        fc = f(c)
        if abs(fc) < tol or (b-a)/2.0 < tol:
            return c
        if fa*fc < 0:
            b = c
            fb = fc
        else:
            a = c
            fa = fc
    return (a+b)/2.0

# Resolución numérica
T_vals = np.linspace(0.001, Tc*0.999, 200) # No queremos que llegue exactamente a T_c
Delta_vals = np.zeros_like(T_vals)  # vector de ceros con la misma forma que T_vals
for i, T in enumerate(T_vals):
    sol = biseccion(lambda D: gap_equation(D, T), 1e-8, Delta0*1.5)
    Delta_vals[i] = sol if sol is not None else 0.0

T_red = T_vals/Tc
Delta_red = Delta_vals/Delta0

# Aproximación analítica cerca de Tc
T_near_Tc = np.linspace(0.60, 0.9999, 80)
Delta_approx = 1.74*np.sqrt(np.maximum(1-T_near_Tc, 0))  # maximum para no meter negativos en la raíz

# Figura
fig, ax = plt.subplots(figsize=(8, 6))
fig.patch.set_facecolor('white')
ax.plot(T_near_Tc, Delta_approx, '--', color='#2471A3', lw=2.2, alpha=0.9,
        zorder=4,
        label=r'$\Delta(T)/\Delta(0) \approx 1{,}74\sqrt{1-T/T_c}$')
ax.plot(T_red, Delta_red, color='#C0392B', lw=2.8,
        zorder=5,
        label=r'Solución numérica BCS')
ax.set_xlabel(r'$T/T_c$', fontsize=14)
ax.set_ylabel(r'$\Delta(T)/\Delta(0)$', fontsize=14)
ax.set_title(r'Gap superconductor BCS frente a la temperatura',
             fontsize=12.5, color='#2C3E50', fontweight='bold', pad=12)
ax.grid(True, alpha=0.3, linestyle='-', linewidth=0.5)
ax.set_xlim(0, 1.05)
ax.set_ylim(0, 1.15)
ax.axhline(y=1, color='gray', lw=2.8, alpha=0.5, linestyle=':')
ax.axvline(x=1, color='gray', lw=2.8, alpha=0.5, linestyle=':')
ax.legend(loc='upper right', fontsize=10.5, framealpha=0.95,
          edgecolor='#2C3E50', fancybox=True)
plt.tight_layout()
plt.savefig('bcs_gap.pdf', bbox_inches='tight', dpi=300)
plt.savefig('bcs_gap.png', bbox_inches='tight', dpi=300)
display(fig)
plt.close(fig)
